import 'package:flutter/material.dart';
import 'package:tuks_divide/components/avatar_widget.dart';

class AddPictureWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color backgroundColor;
  final double radius;
  final double iconSize;
  final VoidCallback onPressed;
  final String? avatarUrl;
  const AddPictureWidget(
      {super.key,
      this.height,
      this.width,
      required this.backgroundColor,
      required this.radius,
      required this.iconSize,
      required this.onPressed,
      this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      AvatarWidget(
        backgroundColor: backgroundColor,
        radius: radius,
        iconSize: iconSize,
        avatarUrl: avatarUrl,
      ),
      Positioned(
        height: height,
        width: width,
        right: -10.0,
        bottom: -10.0,
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          clipBehavior: Clip.hardEdge,
          child: Material(
            type: MaterialType.button,
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
