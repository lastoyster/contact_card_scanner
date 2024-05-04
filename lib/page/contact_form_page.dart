import 'package:contact_card_scanner/model/contact_model.dart';
import 'package:contact_card_scanner/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/dbhelper.dart';
import '../provider/contact_provider.dart';

class FormPage extends StatefulWidget {
  static const String routeName = '/form_Page';
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _nameController = TextEditingController();
  final _designationController = TextEditingController();
  final _companyController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _webController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ContactModel contact;
  @override
  void didChangeDependencies() {
    contact = ModalRoute.of(context)!.settings.arguments as ContactModel;
    _nameController.text = contact.name;
    _designationController.text = contact.designation;
    _companyController.text = contact.company;
    _mobileController.text = contact.mobile;
    _emailController.text = contact.email;
    _addressController.text = contact.address;
    _webController.text = contact.website;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Page'),
        actions: [IconButton(onPressed: _save, icon: Icon(Icons.save))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your name',
                  filled: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Filed must not be empty ';
                }
                if (value.length > 30) {
                  return 'Contact name should not be more than 30 chars long';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _mobileController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.call),
                  hintText: 'mobile number',
                  filled: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Filed must not be empty ';
                }
                if (value.length > 11) {
                  return 'Contact name should not be more than 11 chars long';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enail',
                  filled: true),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _designationController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your designation',
                  filled: true),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your company',
                  filled: true),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.abc),
                  hintText: 'Enter your address',
                  filled: true),
              validator: (value) {
                return null;
              },
            ),
            TextFormField(
              controller: _webController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'enter your website',
                  filled: true),
              validator: (value) {
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      contact.name = _nameController.text;
      contact.mobile = _mobileController.text;
      contact.email = _emailController.text;
      contact.designation = _designationController.text;
      contact.company = _companyController.text;
      contact.address = _addressController.text;
      contact.website = _webController.text;

      print(contact.toString());
      Provider.of<ContactProvider>(context, listen: false)
          .insertContact(contact)
          .then((value) => Navigator.popUntil(
              context, ModalRoute.withName(HomePage.routeName)));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _webController.dispose();
    super.dispose();
  }
}
