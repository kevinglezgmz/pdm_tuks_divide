part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class NoFriendsState extends FriendsState {}

class FriendsErrorState extends FriendsState {
  final String errorMessage;

  const FriendsErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class FriendsLoadedState extends FriendsState {
  final List<UserModel> friends;

  const FriendsLoadedState({required this.friends});

  @override
  List<Object> get props => [friends];
}

class FriendsLoadingState extends FriendsState {}

class FriendsAddingFriendstate extends FriendsState {}

class FriendsAddedFriendstate extends FriendsState {}

class FriendsAddingErrorState extends FriendsState {
  final String errorMessage;

  const FriendsAddingErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
