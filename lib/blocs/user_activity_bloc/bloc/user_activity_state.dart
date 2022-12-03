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
  final List<PaymentModel> myPayments;
  final List<PaymentModel> payback;
  final List<SpendingModel> spendingDoneByMe;
  final List<UserModel> otherUsers;
  final List<GroupSpendingModel> myDebts;
  final List<GroupSpendingModel> owings;

  const UserActivityLoadedState(
      {required this.myPayments,
      required this.payback,
      required this.spendingDoneByMe,
      required this.otherUsers,
      required this.myDebts,
      required this.owings});

  @override
  List<dynamic> get props =>
      [myPayments, payback, spendingDoneByMe, otherUsers, myDebts, owings];
}
