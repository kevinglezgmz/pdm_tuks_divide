import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController inputController;
  final String label;
  final bool obscureText;
  const TextInputField(
      {super.key,
      required this.inputController,
      required this.label,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      obscureText: obscureText,
      decoration: InputDecoration(label: Text(label)),
    );
  }
}
