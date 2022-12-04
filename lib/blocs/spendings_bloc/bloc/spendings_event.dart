part of 'spendings_bloc.dart';

abstract class SpendingsEvent extends Equatable {
  const SpendingsEvent();

  @override
  List<Object> get props => [];
}

class SpendingsResetBlocEvent extends SpendingsEvent {}

class SpendingsAddParticipantEvent extends SpendingsEvent {}

class SpendingUpdateEvent extends SpendingsEvent {
  final NullableSpendingsUseState newState;

  const SpendingUpdateEvent({required this.newState});

  @override
  List<Object> get props => [newState];
}

class SaveSpendingEvent extends SpendingsEvent {
  const SaveSpendingEvent();
  @override
  List<Object> get props => [];
}

class SpendingsSetInitialSpendingsEvent extends SpendingsEvent {}
