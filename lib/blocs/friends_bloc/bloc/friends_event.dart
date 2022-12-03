part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class AddNewFriendByMailEvent extends FriendsEvent {
  final String email;

  const AddNewFriendByMailEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class CleanFriendsListOnSignOutEvent extends FriendsEvent {}

class UpdateFriendsStateEvent extends FriendsEvent {
  final NullableFriendsUseState newState;

  const UpdateFriendsStateEvent({required this.newState});

  @override
  List<Object> get props => [newState];
}
