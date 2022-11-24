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
  Map<String, List<dynamic>> activity;

  UserActivityLoadedState({required this.activity});

  @override
  List<dynamic> get props => [];
}