import 'package:flutter/material.dart';
import 'package:tuks_divide/pages/groups_page/group_item.dart';

class GroupList extends StatelessWidget {
  final List<dynamic> groupData = [
    {
      "groupName": "Disneyland Trip",
      "debtDescription": "No tienes cuentas pendientes :)"
    },
    {
      "groupName": "Mount Rainier :D",
      "debtDescription": "Debes \$25.36 a Andrea"
    },
    {"groupName": "Camping 2k22", "debtDescription": "Te deben \$100.63"}
  ];
  GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: groupData.length,
            itemBuilder: (BuildContext context, int index) {
              return GroupItem(
                groupName: groupData[index]["groupName"],
                groupImage: null,
                debtDescription: groupData[index]["debtDescription"],
              );
            }));
  }
}
