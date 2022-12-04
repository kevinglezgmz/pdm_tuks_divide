import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/models/collections.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'participants_detail_event.dart';
part 'participants_detail_state.dart';

class ParticipantsDetailBloc
    extends Bloc<ParticipantsDetailEvent, ParticipantsDetailState> {
  static final groupsCollection =
      FirebaseFirestore.instance.collection(FirebaseCollections.groups);
  ParticipantsDetailBloc() : super(ParticipantsDetailInitialState()) {
    on<GetParticipantsDetailEvent>(_getParticipantsDetailEventHandler);
  }
  FutureOr<void> _getParticipantsDetailEventHandler(event, emit) async {
    emit(ParticipantsLoadingDetailState());
    try {
      final groupRef = await groupsCollection.doc(event.groupId).get();
      final group = GroupModel.fromMap(
          groupRef.data()!..addAll({'groupId': event.groupId}));
      final participants = await GroupsRepository.getMembersOfGroup(group);
      emit(ParticipantsLoadedDetailState(
          participants: participants, group: group));
    } catch (error) {
      emit(ParticipantsLoadingErrorState());
    }
  }
}
