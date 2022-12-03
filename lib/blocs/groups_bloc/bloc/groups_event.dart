part of 'groups_bloc.dart';

abstract class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class AddNewGroupEvent extends GroupsEvent {
  final String description;
  final String groupName;
  final String pictureUrl;
  final List<UserModel> members;

  const AddNewGroupEvent({
    required this.description,
    required this.groupName,
    required this.members,
    required this.pictureUrl,
  });

  @override
  List<Object> get props => [
        description,
        groupName,
        members,
        pictureUrl,
      ];
}

class LoadUserGroupsEvent extends GroupsEvent {}

class CleanGroupsListOnSignOutEvent extends GroupsEvent {}

class LoadGroupActivityEvent extends GroupsEvent {
  final GroupModel groupData;

  const LoadGroupActivityEvent({
    required this.groupData,
  });

  @override
  List<Object> get props => [
        groupData,
      ];
}
