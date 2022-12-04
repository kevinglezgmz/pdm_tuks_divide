import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/spending_detail_page/participants_list.dart';

class GroupParticipantsDetailPage extends StatelessWidget {
  final List<UserModel> usersInGroup;

  const GroupParticipantsDetailPage({
    super.key,
    required this.usersInGroup,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsUseState>(
        builder: (context, state) {
          if (state.selectedGroup != null && state.groupUsers.isNotEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text(state.selectedGroup!.groupName),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Text(
                      "Participantes",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child:
                          ParticipantsList(participantsData: state.groupUsers),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text("Participantes del grupo"),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text("Ups! No encontramos a los participantes"),
                  )
                ],
              ));
        },
        listener: (context, state) {});
  }
}
