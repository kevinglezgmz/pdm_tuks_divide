import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            : const CircleAvatar(
                child: FaIcon(
                  FontAwesomeIcons.userAstronaut,
                  color: Colors.white,
                  size: 20,
                ),
              ), // TODO: Add logic to put user profile image or default user avatar
        title: Text("$memberName $memberLastName"),
        trailing: const Icon(Icons.delete),
      ),
    );
  }
}
