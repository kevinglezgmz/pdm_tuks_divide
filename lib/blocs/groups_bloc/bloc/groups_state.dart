part of 'groups_bloc.dart';

abstract class GroupsState extends Equatable {
  const GroupsState();

  @override
  List<Object> get props => [];
}

class GroupsUseState extends GroupsState {
  final List<PaymentModel> payments;
  final List<SpendingModel> spendings;
  final List<UserModel> groupUsers;
  final List<GroupModel> userGroups;
  final GroupModel? selectedGroup;
  final bool hasError;
  final bool isLoadingGroups;
  final bool isCreatingGroup;
  final bool isLoadingActivity;
  final bool isLoadingGroupUsers;
  final String errorMessage;

  const GroupsUseState({
    this.userGroups = const [],
    this.hasError = false,
    this.isLoadingGroups = false,
    this.isCreatingGroup = false,
    this.isLoadingActivity = false,
    this.isLoadingGroupUsers = false,
    this.errorMessage = "",
    this.spendings = const [],
    this.payments = const [],
    this.groupUsers = const [],
    this.selectedGroup,
  });

  GroupsUseState copyWith({
    List<PaymentModel>? payments,
    List<SpendingModel>? spendings,
    List<UserModel>? groupUsers,
    List<GroupModel>? userGroups,
    GroupModel? selectedGroup,
    bool? hasError,
    bool? isLoadingGroups,
    bool? isCreatingGroup,
    bool? isLoadingActivity,
    bool? isLoadingGroupUsers,
    String? errorMessage,
  }) {
    return GroupsUseState(
      userGroups: userGroups ?? this.userGroups,
      hasError: hasError ?? this.hasError,
      isLoadingGroups: isLoadingGroups ?? this.isLoadingGroups,
      isCreatingGroup: isCreatingGroup ?? this.isCreatingGroup,
      isLoadingActivity: isLoadingActivity ?? this.isLoadingActivity,
      errorMessage: errorMessage ?? this.errorMessage,
      spendings: spendings ?? this.spendings,
      payments: payments ?? this.payments,
      groupUsers: groupUsers ?? this.groupUsers,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      isLoadingGroupUsers: isLoadingGroupUsers ?? this.isLoadingGroupUsers,
    );
  }

  @override
  List<Object> get props => [
        userGroups,
        hasError,
        isLoadingGroups,
        isCreatingGroup,
        isLoadingActivity,
        errorMessage,
        spendings,
        payments,
        groupUsers,
        isLoadingGroupUsers,
        selectedGroup ?? "No group",
      ];
}

class NullableGroupsUseState extends GroupsState {
  final List<PaymentModel>? payments;
  final List<SpendingModel>? spendings;
  final List<UserModel>? groupUsers;
  final List<GroupModel>? userGroups;
  final GroupModel? selectedGroup;
  final bool? hasError;
  final bool? isLoadingGroups;
  final bool? isCreatingGroup;
  final bool? isLoadingActivity;
  final bool? isLoadingGroupUsers;
  final String? errorMessage;

  const NullableGroupsUseState({
    this.userGroups,
    this.hasError,
    this.isLoadingGroups,
    this.isCreatingGroup,
    this.isLoadingActivity,
    this.isLoadingGroupUsers,
    this.errorMessage,
    this.spendings,
    this.payments,
    this.groupUsers,
    this.selectedGroup,
  });

  @override
  List<Object> get props => [
        userGroups ?? "userGroups",
        hasError ?? "hasError",
        isLoadingGroups ?? "isLoadingGroups",
        isCreatingGroup ?? "isCreatingGroup",
        isLoadingActivity ?? "isLoadingActivity",
        errorMessage ?? "errorMessage",
        spendings ?? "spendings",
        payments ?? "payments",
        groupUsers ?? "groupUsers",
        selectedGroup ?? "selectedGroup",
        isLoadingGroupUsers ?? "isLoadingGroupUsers",
      ];
}
