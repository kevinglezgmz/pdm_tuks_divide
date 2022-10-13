import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AvatarWidget extends StatelessWidget {
  final Color? backgroundColor;
  final double? radius;
  final double iconSize;
  const AvatarWidget(
      {super.key, this.backgroundColor, this.radius, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: backgroundColor,
        radius: radius,
        child: FaIcon(
          FontAwesomeIcons.userAstronaut,
          color: Colors.white,
          size: iconSize,
        ));
  }
}
