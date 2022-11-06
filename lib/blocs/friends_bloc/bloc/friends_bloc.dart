import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_repository.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FriendsRepository _friendsRepository;
  final List<UserModel> _userFriends = [];

  FriendsBloc({required friendsRepository})
      : _friendsRepository = friendsRepository,
        super(FriendsInitial()) {
    on<LoadUserFriendsEvent>(_loadUserFriendsEventHandler);
    on<AddNewFriendByMailEvent>(_addNewFriendByMailEventHandler);
  }

  FutureOr<void> _loadUserFriendsEventHandler(
      LoadUserFriendsEvent event, Emitter<FriendsState> emit) async {
    emit(FriendsLoadingState());
    try {
      final friends = await _friendsRepository.getUserFriends();
      _userFriends.addAll(friends);
      emit(FriendsLoadedState(friends: _userFriends));
    } catch (e) {
      emit(FriendsErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _addNewFriendByMailEventHandler(
      AddNewFriendByMailEvent event, Emitter<FriendsState> emit) async {
    emit(FriendsAddingFriendstate());
    try {
      final List<UserModel> friends = _userFriends
          .where((element) => element.email == event.email)
          .toList();
      if (friends.isNotEmpty) {
        throw 'El usuario con correo ${event.email} ya es tu amigo.';
      }
      final addedFriend = await _friendsRepository.addFriendByMail(event.email);
      if (addedFriend != null) {
        _userFriends.add(addedFriend);
      }
      emit(FriendsAddedFriendstate());
    } catch (e) {
      emit(FriendsAddingErrorState(errorMessage: e.toString()));
    } finally {
      emit(FriendsLoadedState(friends: _userFriends));
    }
  }
}
