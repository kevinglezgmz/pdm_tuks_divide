import 'package:flutter/material.dart';
import 'package:tuks_divide/models/group_model.dart';

class GroupItem extends StatelessWidget {
  final GroupModel groupData;

  const GroupItem({
    super.key,
    required this.groupData,
  });

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
        title: Text(groupData.groupName),
        // TODO: realizar algún cálculo dependiendo de los datos disponibles
        subtitle: const Text('Todo'),
      ),
    );
  }
}
