part of 'update_user_profile_bloc.dart';

abstract class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();

  @override
  List<Object> get props => [];
}

class UpdateUserProfileInitialState extends UpdateUserProfileState {}

class UpdateUserProfileLoadingState extends UpdateUserProfileState {}

class UpdateUserProfileLoadedState extends UpdateUserProfileState {}

class UpdateUserProfileRefreshState extends UpdateUserProfileState {}

class UpdateUserProfileErrorState extends UpdateUserProfileState {}
