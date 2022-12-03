import 'package:flutter/material.dart';
import 'package:tuks_divide/components/avatar_widget.dart';
import 'package:tuks_divide/models/user_model.dart';

class MemberItem extends StatelessWidget {
  final String fullName;
  final String? profilePicture;
  final void Function() onDeleteTap;
  final UserModel? me;
  const MemberItem({
    super.key,
    required this.fullName,
    required this.profilePicture,
    required this.onDeleteTap,
    this.me,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: ListTile(
          title: Text("$fullName${me != null ? " (tú)" : ""}"),
          trailing: (me == null)
              ? IconButton(
                  onPressed: onDeleteTap,
                  icon: const Icon(Icons.delete),
                )
              : null,
          leading: profilePicture != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(profilePicture!),
                )
              : const AvatarWidget(iconSize: 20),
        ),
      ),
    );
  }
}
