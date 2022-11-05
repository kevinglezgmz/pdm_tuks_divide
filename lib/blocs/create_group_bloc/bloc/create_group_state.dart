part of 'create_group_bloc.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object> get props => [];
}

class CreateGroupInitial extends CreateGroupState {}

class CreateGroupSelectedMembersState extends CreateGroupState {
  final List<UserModel> currentGroupMembers;

  const CreateGroupSelectedMembersState({required this.currentGroupMembers});

  @override
  List<Object> get props => currentGroupMembers;
}
