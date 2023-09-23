import 'package:flutter/material.dart';

class BonusTextField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  const BonusTextField({super.key, required this.controller, this.onChanged});

  @override
  State<BonusTextField> createState() => _BonusTextFieldState();
}

class _BonusTextFieldState extends State<BonusTextField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        width: size.width / 3,
        height: size.height / 17,
        child: TextFormField(
          onChanged: widget.onChanged,
          controller: widget.controller,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.yellow),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.yellow, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
