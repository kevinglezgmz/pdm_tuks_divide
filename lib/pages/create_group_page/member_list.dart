import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/create_group_bloc/bloc/create_group_bloc.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/create_group_page/member_item.dart';

class MemberList extends StatelessWidget {
  final List<UserModel> membersData;
  const MemberList({super.key, required this.membersData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: membersData.length,
        itemBuilder: (BuildContext context, int index) {
          return MemberItem(
            fullName: membersData[index].displayName ??
                membersData[index].fullName ??
                '<No Name>',
            profilePicture: membersData[index].pictureUrl,
            onDeleteTap: () {
              BlocProvider.of<CreateGroupBloc>(context).add(
                RemoveMemberFromGroupCreateEvent(
                  userToRemove: membersData[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
