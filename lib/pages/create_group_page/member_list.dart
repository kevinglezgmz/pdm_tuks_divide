import 'package:flutter/material.dart';
import 'package:tuks_divide/pages/create_group_page/member_item.dart';

class MemberList extends StatelessWidget {
  final List<dynamic> membersData = [
    {"name": "ana", "lastName": "perez"},
    {"name": "kevin", "lastName": "gonzalez"}
  ];
  MemberList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: membersData.length,
            itemBuilder: (BuildContext context, int index) {
              return MemberItem(
                memberName: membersData[index]["name"],
                memberLastName: membersData[index]["lastName"],
                profilePicture: null,
              );
            }));
  }
}
