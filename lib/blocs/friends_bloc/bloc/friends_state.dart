part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();

  @override
  List<Object> get props => [];
}

class FriendsUseState extends FriendsState {
  final bool isLoadingFriends;
  final bool isAddingFriend;
  final List<UserModel> friends;
  final String errorMessage;

  const FriendsUseState({
    this.isLoadingFriends = false,
    this.isAddingFriend = false,
    this.friends = const [],
    this.errorMessage = "",
  });

  FriendsUseState copyWith({
    bool? isLoadingFriends,
    bool? isAddingFriend,
    List<UserModel>? friends,
    String? errorMessage,
  }) {
    return FriendsUseState(
      isLoadingFriends: isLoadingFriends ?? this.isLoadingFriends,
      isAddingFriend: isAddingFriend ?? this.isAddingFriend,
      friends: friends ?? this.friends,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        isLoadingFriends,
        isAddingFriend,
        friends,
        errorMessage,
      ];
}

class NullableFriendsUseState extends FriendsState {
  final bool? isLoadingFriends;
  final bool? isAddingFriend;
  final List<UserModel>? friends;
  final String? errorMessage;

  const NullableFriendsUseState({
    this.isLoadingFriends,
    this.isAddingFriend,
    this.friends,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        isLoadingFriends ?? 'isLoadingFriends',
        isAddingFriend ?? 'isAddingFriend',
        friends ?? 'friends',
        errorMessage ?? 'errorMessage',
      ];
}
