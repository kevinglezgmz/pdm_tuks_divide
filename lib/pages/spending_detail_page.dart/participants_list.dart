import 'package:flutter/material.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/spending_detail_page.dart/participant_item.dart';

class ParticipantsList extends StatelessWidget {
  final List<UserModel> participantsData;
  const ParticipantsList({super.key, required this.participantsData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: participantsData.length,
        itemBuilder: (BuildContext context, int index) {
          return ParticipantItem(
            userData: participantsData[index],
            onTap: () {},
          );
        },
      ),
    );
  }
}
