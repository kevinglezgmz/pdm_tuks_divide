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
      child: ListTile(
        //TODO: add logic to put group image
        title: Text(groupData.groupName),
        // TODO: realizar algún cálculo dependiendo de los datos disponibles
        subtitle: Text(groupData.description),
        //TODO: add logic to put group image
        leading: CircleAvatar(
            backgroundImage: groupData.groupPicUrl == null ||
                    groupData.groupPicUrl == ""
                ? const NetworkImage(
                    "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                : NetworkImage(groupData.groupPicUrl!)),
      ),
    );
  }
}
