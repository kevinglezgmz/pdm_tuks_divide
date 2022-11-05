import 'package:flutter/material.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/pages/groups_page/group_item.dart';

class GroupList extends StatelessWidget {
  final List<GroupModel> groupData;
  const GroupList({super.key, required this.groupData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: groupData.length,
        itemBuilder: (BuildContext context, int index) {
          return GroupItem(
            groupData: groupData[index],
          );
        },
      ),
    );
  }
}
