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

class CleanGroupsListOnSignOutEvent extends GroupsEvent {}

class UpdateGroupsStateEvent extends GroupsEvent {
  final NullableGroupsUseState newState;

  const UpdateGroupsStateEvent({required this.newState});

  @override
  List<Object> get props => [newState];
}

class LoadGroupUsersEvent extends GroupsEvent {
  final GroupModel group;

  const LoadGroupUsersEvent({required this.group});

  @override
  List<Object> get props => [group];
}
