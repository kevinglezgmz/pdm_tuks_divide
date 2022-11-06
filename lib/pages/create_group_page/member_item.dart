import 'package:flutter/material.dart';
import 'package:tuks_divide/components/avatar_widget.dart';

class MemberItem extends StatelessWidget {
  final String fullName;
  final String? profilePicture;
  final void Function() onDeleteTap;
  const MemberItem({
    super.key,
    required this.fullName,
    required this.profilePicture,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: profilePicture != null
            ? CircleAvatar(
                child: Image.network(profilePicture!),
              )
            : const AvatarWidget(iconSize: 20),
        title: Text(fullName),
        trailing: GestureDetector(
          onTap: onDeleteTap,
          child: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
