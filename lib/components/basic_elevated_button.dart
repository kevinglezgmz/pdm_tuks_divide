import 'package:flutter/material.dart';

class BasicElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  const BasicElevatedButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: createStyle(),
      child: Text(
        label,
      ),
    );
  }

  ButtonStyle createStyle() {
    return ElevatedButton.styleFrom(
        foregroundColor: Colors.grey[350],
        minimumSize: const Size.fromHeight(50),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.0),
        ));
  }
}
