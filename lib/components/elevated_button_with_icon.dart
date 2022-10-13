import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/components/basic_elevated_button.dart';

class ElevatedButtonWithIcon extends BasicElevatedButton {
  final FaIcon icon;
  const ElevatedButtonWithIcon(
      {super.key,
      required this.icon,
      required super.onPressed,
      required super.label,
      required super.backgroundColor})
      : super();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: super.onPressed,
      icon: icon,
      style: super.createStyle(),
      label: Text(super.label),
    );
  }
}
