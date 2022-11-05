import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  final String groupName;
  final String? groupImage;
  final String debtDescription;

  const GroupItem(
      {super.key,
      required this.groupName,
      required this.groupImage,
      required this.debtDescription});

  @override
  Widget build(BuildContext context) {
    return Card(
      //TODO: add logic to put group image
      child: ListTile(
        leading: CircleAvatar(
            child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.cyan[200],
          ),
        )),
        title: Text(groupName),
        subtitle: Text(debtDescription),
      ),
    );
  }
}
