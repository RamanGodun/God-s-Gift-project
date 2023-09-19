import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  final String? text;

  CustomSnackBar({super.key, this.text, required BuildContext context})
      : super(
          backgroundColor: Colors.black,
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              text!,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          duration: const Duration(seconds: 2, milliseconds: 3),
        );
}
