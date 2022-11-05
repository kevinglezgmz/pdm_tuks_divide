import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final List<UserModel> _currentGroupMembers = [];

  List<UserModel> get members => _currentGroupMembers;

  CreateGroupBloc() : super(CreateGroupInitial()) {
    on<InitGroupCreateEvent>(_initGroupCreateEventHandler);
    on<AddMemberToGroupCreateEvent>(_addMemberToGroupCreateEventHandler);
    on<RemoveMemberFromGroupCreateEvent>(
        _removeMemberFromGroupCreateEventHandler);
  }

  FutureOr<void> _addMemberToGroupCreateEventHandler(
      AddMemberToGroupCreateEvent event, Emitter<CreateGroupState> emit) {
    _currentGroupMembers.add(event.userToAdd);
    emit(CreateGroupInitial());
    emit(CreateGroupSelectedMembersState(
        currentGroupMembers: _currentGroupMembers));
  }

  FutureOr<void> _removeMemberFromGroupCreateEventHandler(
      RemoveMemberFromGroupCreateEvent event, Emitter<CreateGroupState> emit) {
    _currentGroupMembers.remove(event.userToRemove);
    emit(CreateGroupInitial());
    emit(CreateGroupSelectedMembersState(
        currentGroupMembers: _currentGroupMembers));
  }

  FutureOr<void> _initGroupCreateEventHandler(
      InitGroupCreateEvent event, Emitter<CreateGroupState> emit) {
    emit(CreateGroupInitial());
    _currentGroupMembers.clear();
    emit(CreateGroupSelectedMembersState(
        currentGroupMembers: _currentGroupMembers));
  }
}
