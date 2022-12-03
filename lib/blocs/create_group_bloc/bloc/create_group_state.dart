part of 'create_group_bloc.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object> get props => [];
}

class CreateGroupUseState extends CreateGroupState {
  final List<UserModel> membersInGroup;

  const CreateGroupUseState({
    this.membersInGroup = const [],
  });

  @override
  List<Object> get props => [membersInGroup];
}
