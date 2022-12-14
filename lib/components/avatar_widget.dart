import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final Color? backgroundColor;
  final double? radius;
  final double iconSize;
  final String? avatarUrl;
  const AvatarWidget(
      {super.key,
      this.backgroundColor,
      this.radius,
      required this.iconSize,
      this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: backgroundColor,
        radius: radius,
        backgroundImage: avatarUrl == null || avatarUrl == ""
            ? const NetworkImage(
                "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
            : NetworkImage(avatarUrl!));
  }
}
