import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/participants_detail_bloc/bloc/participants_detail_bloc.dart';
import 'package:tuks_divide/pages/spending_detail_page/participants_list.dart';

class GroupParticipantsDetailPage extends StatelessWidget {
  const GroupParticipantsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParticipantsDetailBloc, ParticipantsDetailState>(
        builder: (context, state) {
          if (state is ParticipantsLoadedDetailState) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(state.group.groupName),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Text(
                        "Participantes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    ParticipantsList(participantsData: state.participants),
                  ],
                ));
          }
          if (state is ParticipantsLoadingDetailState) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Participantes del grupo"),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ));
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
