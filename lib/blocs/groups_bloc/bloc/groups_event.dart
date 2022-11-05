part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class AddNewGroupEvent extends GroupsEvent {
  final GroupModel groupData;

  const AddNewGroupEvent({required this.groupData});

  @override
  List<Object> get props => [groupData];
}

class LoadUserGroupsEvent extends GroupsEvent {}
