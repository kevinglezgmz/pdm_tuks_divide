part of 'user_activity_bloc.dart';

abstract class UserActivityState extends Equatable {
  const UserActivityState();

  @override
  List<dynamic> get props => [];
}

class UserActivityInitialState extends UserActivityState {}

class UserActivityLoadingState extends UserActivityState {}

class UserActivityErrorState extends UserActivityState {}

class UserActivityLoadedState extends UserActivityState {
  final List<PaymentModel> spendingRefs;
  final List<PaymentModel> debtRefs;
  final List<SpendingModel> spentRefs;
  final List<UserModel> users;
  final List<GroupSpendingModel> noDebt;
  final List<GroupSpendingModel> owingRefs;
  final List<GroupSpendingModel> myDebtRefs;

  const UserActivityLoadedState(
      {required this.spendingRefs,
      required this.debtRefs,
      required this.spentRefs,
      required this.users,
      required this.noDebt,
      required this.owingRefs,
      required this.myDebtRefs});

  @override
  List<dynamic> get props =>
      [spendingRefs, debtRefs, spentRefs, users, noDebt, owingRefs, myDebtRefs];
}
