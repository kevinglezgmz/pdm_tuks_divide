import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GroupsRepository groupsRepository;
  final List<GroupModel> _userGroups = [];

  GroupsBloc({required this.groupsRepository}) : super(GroupsInitial()) {
    on<LoadUserGroupsEvent>(_loadUserGroupsEventHandler);
    on<AddNewGroupEvent>(_addNewGroupEventHandler);
  }

  FutureOr<void> _loadUserGroupsEventHandler(
      LoadUserGroupsEvent event, Emitter<GroupsState> emit) async {
    emit(GroupsLoadingState());
    try {
      final groups = await groupsRepository.getUserGroups();
      _userGroups.addAll(groups);
      emit(GroupsLoadedState(groups: _userGroups));
    } catch (e) {
      emit(GroupsErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _addNewGroupEventHandler(
      AddNewGroupEvent event, Emitter<GroupsState> emit) async {
    emit(GroupsCreatingGroupState());
    try {
      final GroupModel? createdGroup = await groupsRepository
          .createNewUserGroup(event.groupData, event.members);
      if (createdGroup != null) {
        _userGroups.add(createdGroup);
      }
      emit(GroupsCreatedGroupState());
      emit(GroupsLoadedState(groups: _userGroups));
    } catch (e) {
      emit(GroupsCreatingErrorState(errorMessage: e.toString()));
    }
  }
}
