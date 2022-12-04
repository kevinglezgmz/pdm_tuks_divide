import 'package:flutter/material.dart';
import 'package:tuks_divide/models/user_model.dart';

class ParticipantItem extends StatelessWidget {
  final UserModel userData;
  final VoidCallback onTap;
  const ParticipantItem(
      {super.key, required this.userData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(userData.displayName ?? userData.fullName ?? "<No Name>"),
          leading: CircleAvatar(
              backgroundImage: userData.pictureUrl == null ||
                      userData.pictureUrl == ""
                  ? const NetworkImage(
                      "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                  : NetworkImage(userData.pictureUrl!)),
        ),
      ),
    );
  }
}
