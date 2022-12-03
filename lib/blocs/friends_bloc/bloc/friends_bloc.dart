import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_repository.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsUseState> {
  final FriendsRepository _friendsRepository;

  FriendsBloc({required friendsRepository})
      : _friendsRepository = friendsRepository,
        super(const FriendsUseState()) {
    on<AddNewFriendByMailEvent>(_addNewFriendByMailEventHandler);
    on<CleanFriendsListOnSignOutEvent>(_resetFriendsBloc);
    on<UpdateFriendsStateEvent>(_updateFriendsStateEventHandler);
  }

  FutureOr<void> _addNewFriendByMailEventHandler(
      AddNewFriendByMailEvent event, Emitter<FriendsUseState> emit) async {
    emit(state.copyWith(isAddingFriend: true));
    try {
      final List<UserModel> friends = state.friends
          .where((element) => element.email == event.email)
          .toList();
      if (friends.isNotEmpty) {
        throw 'El usuario con correo ${event.email} ya es tu amigo.';
      }
      await _friendsRepository.addFriendByMail(event.email);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(
        isAddingFriend: false,
        errorMessage: "",
      ));
    }
  }

  _resetFriendsBloc(event, emit) {
    emit(const FriendsUseState());
  }

  void _updateFriendsStateEventHandler(
    UpdateFriendsStateEvent event,
    Emitter<FriendsUseState> emit,
  ) {
    emit(state.copyWith(
      errorMessage: event.newState.errorMessage,
      friends: event.newState.friends,
      isAddingFriend: event.newState.isAddingFriend,
      isLoadingFriends: event.newState.isLoadingFriends,
    ));
  }
}
