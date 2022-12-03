import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupUseState> {
  CreateGroupBloc() : super(const CreateGroupUseState()) {
    on<InitGroupCreateEvent>(_initGroupCreateEventHandler);
    on<AddMemberToGroupCreateEvent>(_addMemberToGroupCreateEventHandler);
    on<RemoveMemberFromGroupCreateEvent>(
        _removeMemberFromGroupCreateEventHandler);
  }

  FutureOr<void> _addMemberToGroupCreateEventHandler(
      AddMemberToGroupCreateEvent event, Emitter<CreateGroupUseState> emit) {
    final List<UserModel> newList = [...state.membersInGroup, event.userToAdd];
    emit(CreateGroupUseState(membersInGroup: [...newList]));
  }

  FutureOr<void> _removeMemberFromGroupCreateEventHandler(
      RemoveMemberFromGroupCreateEvent event,
      Emitter<CreateGroupUseState> emit) {
    final List<UserModel> newList = state.membersInGroup
        .where((element) => element != event.userToRemove)
        .toList();
    emit(CreateGroupUseState(membersInGroup: [...newList]));
  }

  FutureOr<void> _initGroupCreateEventHandler(
      InitGroupCreateEvent event, Emitter<CreateGroupUseState> emit) {
    emit(const CreateGroupUseState());
  }
}
