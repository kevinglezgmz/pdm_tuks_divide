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
    on<AddNewGroupEvent>(_addNewGroupEventHandler);
    on<CleanGroupsListOnSignOutEvent>(_resetGroupsState);
    on<LoadGroupUsersEvent>(_loadGroupUsersHandler);
    on<UpdateGroupsStateEvent>(_updateGroupsStateEventHandler);
  }

  FutureOr<void> _addNewGroupEventHandler(
      AddNewGroupEvent event, Emitter<GroupsState> emit) async {
    emit(state.copyWith(isCreatingGroup: true));
    try {
      await groupsRepository.createNewUserGroup(
        event.description,
        event.groupName,
        event.pictureUrl,
        event.members,
      );
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
    emit(const GroupsUseState());
  }

  FutureOr<void> _loadGroupActivityHandler(
    Emitter<GroupsUseState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingActivity: true,
      payments: [],
      spendings: [],
    ));
    try {
      final groupActivity = await groupsRepository.getGroupActivity(
          state.selectedGroup!, state.groupUsers);
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
      UpdateGroupsStateEvent event, Emitter<GroupsUseState> emit) {
    emit(state.copyWith(
      userGroups: event.newState.userGroups,
      hasError: event.newState.hasError,
      isLoadingGroups: event.newState.isLoadingGroups,
      isCreatingGroup: event.newState.isCreatingGroup,
      isLoadingActivity: event.newState.isLoadingActivity,
      errorMessage: event.newState.errorMessage,
      spendings: event.newState.spendings,
      payments: event.newState.payments,
      groupUsers: event.newState.groupUsers,
      selectedGroup: event.newState.selectedGroup,
      isLoadingGroupUsers: event.newState.isLoadingGroupUsers,
    ));
  }

  FutureOr<void> _loadGroupUsersHandler(
      LoadGroupUsersEvent event, Emitter<GroupsUseState> emit) async {
    emit(state.copyWith(
        groupUsers: [], selectedGroup: null, isLoadingGroupUsers: true));
    try {
      List<UserModel> usersInGroup =
          await GroupsRepository.getMembersOfGroup(event.group);
      emit(state.copyWith(
        groupUsers: usersInGroup,
        selectedGroup: event.group,
      ));
      await _loadGroupActivityHandler(emit);
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), selectedGroup: null, hasError: true));
    } finally {
      emit(state.copyWith(isLoadingGroupUsers: false, hasError: false));
    }
  }
}
