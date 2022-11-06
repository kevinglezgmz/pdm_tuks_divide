part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class AddNewGroupEvent extends GroupsEvent {
  final GroupModel groupData;
  final List<UserModel> members;

  const AddNewGroupEvent({required this.groupData, required this.members});

  @override
  List<Object> get props => [groupData, members];
}

class LoadUserGroupsEvent extends GroupsEvent {}
