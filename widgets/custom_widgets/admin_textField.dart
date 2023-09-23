import 'package:flutter/material.dart';

class AdminTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;

  AdminTextField({this.controller, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: labelText),
        controller: controller,
      ),
    );
  }
}
