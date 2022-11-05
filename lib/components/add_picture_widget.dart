import 'package:flutter/material.dart';
import 'package:tuks_divide/components/avatar_widget.dart';

class AddPictureWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color backgroundColor;
  final double radius;
  final double iconSize;
  final VoidCallback onPressed;
  const AddPictureWidget(
      {super.key,
      this.height,
      this.width,
      required this.backgroundColor,
      required this.radius,
      required this.iconSize,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      AvatarWidget(
          backgroundColor: backgroundColor, radius: radius, iconSize: iconSize),
      Positioned(
        height: height,
        width: width,
        right: -10.0,
        bottom: -10.0,
        child: FloatingActionButton(
          heroTag: null,
          onPressed: onPressed,
          child: const Icon(
            Icons.add_a_photo_outlined,
            color: Colors.white,
          ),
        ),
      )
    ]);
  }
}
