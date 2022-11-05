part of 'groups_bloc.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();

  @override
  List<Object> get props => [];
}

class GroupsInitial extends GroupsState {}

class NoGroupsState extends GroupsState {}

class GroupsErrorState extends GroupsState {
  final String errorMessage;

  const GroupsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class GroupsLoadedState extends GroupsState {
  final List<GroupModel> groups;

  const GroupsLoadedState({required this.groups});

  @override
  List<Object> get props => [groups];
}

class GroupsLoadingState extends GroupsState {}

class GroupsCreatingGroupState extends GroupsState {}

class GroupsCreatedGroupState extends GroupsState {}

class GroupsCreatingErrorState extends GroupsState {
  final String errorMessage;

  const GroupsCreatingErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
