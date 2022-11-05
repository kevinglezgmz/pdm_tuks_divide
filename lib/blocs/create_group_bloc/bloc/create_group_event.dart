part of 'create_group_bloc.dart';

abstract class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();

  @override
  List<Object> get props => [];
}

class AddMemberToGroupCreateEvent extends CreateGroupEvent {
  final UserModel userToAdd;

  const AddMemberToGroupCreateEvent({required this.userToAdd});

  @override
  List<Object> get props => [userToAdd];
}

class RemoveMemberFromGroupCreateEvent extends CreateGroupEvent {
  final UserModel userToRemove;

  const RemoveMemberFromGroupCreateEvent({required this.userToRemove});

  @override
  List<Object> get props => [userToRemove];
}

class InitGroupCreateEvent extends CreateGroupEvent {}
