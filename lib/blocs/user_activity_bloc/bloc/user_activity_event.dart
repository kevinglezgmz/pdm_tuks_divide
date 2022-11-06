part of 'user_activity_bloc.dart';

abstract class UserActivityEvent extends Equatable {
  const UserActivityEvent();

  @override
  List<Object> get props => [];
}

class UserActivityLoadEvent extends UserActivityEvent {}
