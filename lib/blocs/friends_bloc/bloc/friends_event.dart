part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadUserFriendsEvent extends FriendsEvent {}

class AddNewFriendByMailEvent extends FriendsEvent {
  final String email;

  const AddNewFriendByMailEvent({required this.email});

  @override
  List<Object> get props => [email];
}
