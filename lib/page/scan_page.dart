import 'dart:io';
import 'package:contact_card_scanner/page/contact_form_page.dart';
import 'package:contact_card_scanner/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import '../customwidgets/drag_target_item.dart';
import '../model/contact_model.dart';

class ScanPage extends StatefulWidget {
  static const String routeName = '/scan';
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool isScanOver = false;
  List<String> lines = [];
  String name = '',
      mobile = '',
      email = '',
      address = '',
      company = '',
      designation = '',
      website = '',
      image = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Card'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: _createContactModelFromScannedValues,
            child: const Text('NEXT'),
          )
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text('Capture'),
              ),
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo_album),
                label: const Text('Gallery'),
              ),
            ],
          ),
          if (isScanOver)
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    DragTargetItem(
                      property: ContactProperties.name,
                      onDrop: _getPropertyValue,
                    ),
                    DragTargetItem(
                      property: ContactProperties.designation,
                      onDrop: _getPropertyValue,
                    ),
                    DragTargetItem(
                      property: ContactProperties.company,
                      onDrop: _getPropertyValue,
                    ),
                    DragTargetItem(
                      property: ContactProperties.address,
                      onDrop: _getPropertyValue,
                    ),
                    DragTargetItem(
                      property: ContactProperties.email,
                      onDrop: _getPropertyValue,
                    ),
                    DragTargetItem(
                      property: ContactProperties.mobile,
                      onDrop: _getPropertyValue,
                    ),
                    DragTargetItem(
                      property: ContactProperties.website,
                      onDrop: _getPropertyValue,
                    ),
                  ],
                ),
              ),
            ),
          if (isScanOver)
            Padding(
              padding: const EdgeInsets.all(8),
              child: const Text(
                  'Long press and Drag each item from the below list and drop above in the appropriate box. You can drop multiple items over a single box.'),
            ),
          Wrap(
            children: lines.map((line) => LineItem(line: line)).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      image = pickedFile.path;
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textRecognizer
          .processImage(InputImage.fromFile(File(pickedFile.path)));
      setState(() {
        isScanOver = true;
      });
      final tempList = <String>[];
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          tempList.add(line.text);
        }
      }
      print(tempList);
      setState(() {
        lines = tempList;
      });
    }
  }

  void _getPropertyValue(String property, String value) {
    switch (property) {
      case ContactProperties.name:
        name = value;
        break;
      case ContactProperties.mobile:
        mobile = value;
        break;
      case ContactProperties.email:
        email = value;
        break;
      case ContactProperties.address:
        address = value;
        break;
      case ContactProperties.company:
        company = value;
        break;
      case ContactProperties.designation:
        designation = value;
        break;
      case ContactProperties.website:
        website = value;
        break;
    }
  }

  void _createContactModelFromScannedValues() {
    final contact = ContactModel(
      name: name,
      mobile: mobile,
      email: email,
      address: address,
      company: company,
      designation: designation,
      website: website,
      image: image,
    );
    Navigator.pushNamed(context, FormPage.routeName, arguments: contact);
  }
}

class LineItem extends StatelessWidget {
  final String line;
  const LineItem({Key? key, required this.line}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey _globalKey = GlobalKey();
    return LongPressDraggable<String>(
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,
      feedback: Container(
        key: _globalKey,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black45,
        ),
        child: Text(line,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white)),
      ),
      child: Chip(
        label: Text(line),
      ),
    );
  }
}
