part of 'user_activity_bloc.dart';

abstract class UserActivityEvent extends Equatable {
  const UserActivityEvent();

  @override
  List<Object> get props => [];
}

class UserActivityUpdateStateEvent extends UserActivityEvent {
  final NullableUserActivityUseState newState;

  const UserActivityUpdateStateEvent({required this.newState});

  @override
  List<Object> get props => [newState];
}
