import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final controller;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText),
    );
  }
}
