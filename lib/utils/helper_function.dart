import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger
      .of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
}

showSingleTextInputDialog({
  required BuildContext context,
  required String title,
  TextInputType inputType = TextInputType.text,
  required Function(String) onUpdate,
}) {
  final controller = TextEditingController();
  showDialog(context: context, builder: (context) => AlertDialog(
    title: Text('Update $title'),
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: inputType,
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter new $title',
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          if(controller.text.isEmpty) return;
          onUpdate(controller.text);
          Navigator.pop(context);
        },
        child: const Text('Update'),
      ),
    ],
  ));
}