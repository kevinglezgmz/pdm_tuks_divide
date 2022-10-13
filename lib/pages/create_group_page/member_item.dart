import 'package:flutter/material.dart';
import 'package:tuks_divide/components/avatar_widget.dart';

class MemberItem extends StatelessWidget {
  final String memberName;
  final String memberLastName;
  final String? profilePicture;
  const MemberItem(
      {super.key,
      required this.memberName,
      required this.memberLastName,
      required this.profilePicture});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: profilePicture != null
            ? CircleAvatar(
                child: Image.network(profilePicture!),
              )
            : const AvatarWidget(iconSize: 20),
        title: Text("$memberName $memberLastName"),
        trailing: const Icon(Icons.delete),
      ),
    );
  }
}
