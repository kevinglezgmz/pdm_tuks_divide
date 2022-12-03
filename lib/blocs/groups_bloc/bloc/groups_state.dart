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

class GroupActivityLoadedState extends GroupsState {
  final List<PaymentModel> payments;
  final List<SpendingModel> spendings;
  final List<UserModel> groupUsers;

  const GroupActivityLoadedState(
      {required this.payments,
      required this.spendings,
      required this.groupUsers});

  @override
  List<Object> get props => [
        payments,
        spendings,
        groupUsers,
      ];
}

class GroupActivityLoadingState extends GroupsState {}

class GroupActivityLoadingErrorState extends GroupsState {
  final String errorMessage;

  const GroupActivityLoadingErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
