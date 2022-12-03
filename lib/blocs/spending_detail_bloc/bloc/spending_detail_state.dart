part of 'spending_detail_bloc.dart';

abstract class SpendingDetailState extends Equatable {
  const SpendingDetailState();

  @override
  List<Object> get props => [];
}

class SpendingDetailInitialState extends SpendingDetailState {}

class SpendingLoadingDetailState extends SpendingDetailState {}

class SpendingLoadingErrorState extends SpendingDetailState {}

class SpendingLoadedDetailState extends SpendingDetailState {
  final SpendingModel spending;
  final List<UserModel> participants;
  final UserModel addedBy;

  const SpendingLoadedDetailState(
      {required this.spending,
      required this.participants,
      required this.addedBy});

  @override
  List<Object> get props => [spending, participants, addedBy];
}
