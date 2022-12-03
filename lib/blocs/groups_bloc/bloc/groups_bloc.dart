import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsUseState> {
  final GroupsRepository groupsRepository;

  GroupsBloc({required this.groupsRepository}) : super(const GroupsUseState()) {
    on<LoadUserGroupsEvent>(_loadUserGroupsEventHandler);
    on<AddNewGroupEvent>(_addNewGroupEventHandler);
    on<CleanGroupsListOnSignOutEvent>(_resetGroupsState);
    on<LoadGroupActivityEvent>(_loadGroupActivityHandler);
    on<UpdateGroupsStateEvent>(_updateGroupsStateEventHandler);
  }

  FutureOr<void> _loadUserGroupsEventHandler(
      LoadUserGroupsEvent event, Emitter<GroupsState> emit) async {
    emit(state.copyWith(isLoadingGroups: true));
    try {
      final groups = await groupsRepository.getUserGroups();
      emit(state.copyWith(userGroups: groups));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        hasError: true,
      ));
    } finally {
      emit(state.copyWith(
        isLoadingGroups: false,
        hasError: false,
      ));
    }
  }

  FutureOr<void> _addNewGroupEventHandler(
      AddNewGroupEvent event, Emitter<GroupsState> emit) async {
    emit(state.copyWith(isCreatingGroup: true));
    try {
      final GroupModel? createdGroup =
          await groupsRepository.createNewUserGroup(
        event.description,
        event.groupName,
        event.pictureUrl,
        event.members,
      );
      if (createdGroup != null) {
        emit(state.copyWith(userGroups: [...state.userGroups, createdGroup]));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
        hasError: true,
      ));
    } finally {
      emit(state.copyWith(
        isCreatingGroup: false,
        errorMessage: "",
        hasError: false,
      ));
    }
  }

  void _resetGroupsState(
      CleanGroupsListOnSignOutEvent event, Emitter<GroupsUseState> emit) {
    _updateState(emit, const GroupsUseState());
  }

  FutureOr<void> _loadGroupActivityHandler(
    LoadGroupActivityEvent event,
    Emitter<GroupsUseState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingActivity: true,
      payments: [],
      spendings: [],
      groupUsers: [],
    ));
    try {
      final groupActivity =
          await groupsRepository.getGroupActivity(event.groupData);
      if (groupActivity == null) {
        throw "Group Activity not found";
      }
      emit(
        state.copyWith(
          payments: groupActivity.payments,
          spendings: groupActivity.spendings,
          groupUsers: groupActivity.groupUsers,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        errorMessage: "Error al obtener la actividad del grupo",
        hasError: true,
      ));
    } finally {
      emit(state.copyWith(
        isLoadingActivity: false,
        errorMessage: "",
        hasError: false,
      ));
    }
  }

  void _updateGroupsStateEventHandler(
      UpdateGroupsStateEvent event, Emitter<GroupsUseState> emit) {}

  void _updateState(Emitter<GroupsUseState> emit, GroupsUseState newState) {
    emit(state.copyWith(
      userGroups: newState.userGroups,
      hasError: newState.hasError,
      isLoadingGroups: newState.isLoadingGroups,
      isCreatingGroup: newState.isCreatingGroup,
      isLoadingActivity: newState.isLoadingActivity,
      errorMessage: newState.errorMessage,
      spendings: newState.spendings,
      payments: newState.payments,
      groupUsers: newState.groupUsers,
      selectedGroup: newState.selectedGroup,
    ));
  }
}
