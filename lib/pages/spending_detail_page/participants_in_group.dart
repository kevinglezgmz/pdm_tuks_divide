import 'package:flutter/material.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/spending_detail_page/participant_item_in_group.dart';

class ParticipantsInGroup extends StatelessWidget {
  final List<UserModel> participantsData;
  const ParticipantsInGroup({super.key, required this.participantsData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: participantsData.length,
      itemBuilder: (BuildContext context, int index) {
        return ParticipantItemInGroup(
          userData: participantsData[index],
          onTap: () {},
        );
      },
    );
  }
}
