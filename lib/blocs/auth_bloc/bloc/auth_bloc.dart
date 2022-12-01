import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_repository.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  UserModel? _me;
  UserModel? get me => _me;

  AuthBloc({required this.authRepository}) : super(AuthNotLoggedInState()) {
    on<AuthEmailLoginEvent>(_initiatePasswordLoginEvent);
    on<AuthGoogleLoginEvent>(_initiateGoogleLoginEvent);
    on<AuthEmailSignupEvent>(_initiateEmailSignupEvent);
    on<AuthCheckLoginStatusEvent>(_checkLoginStatusEvent);
    on<AuthSignOutEvent>(_signoutStatusEvent);
    on<AuthUserDataUpdatedEvent>(_getUserUpdatedData);
  }

  FutureOr<void> _checkLoginStatusEvent(
      AuthCheckLoginStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoggingInState());
    UserModel? user = await authRepository.getMeUser();
    if (user != null) {
      _me = user;
      emit(AuthLoggedInState(user: user));
    } else {
      emit(AuthNotLoggedInState());
    }
  }

  FutureOr<void> _initiatePasswordLoginEvent(
      AuthEmailLoginEvent event, Emitter<AuthState> emit) async {
    try {
      final UserModel user =
          await authRepository.signInWithEmail(event.email, event.password);
      _me = user;
      emit(AuthLoggedInState(user: user));
    } catch (e) {
      // To Do Create Signup Error State
      emit(AuthNotLoggedInState());
    }
  }

  FutureOr<void> _initiateGoogleLoginEvent(
      AuthGoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoggingInState());
    try {
      final UserModel user = await authRepository.signInWithGoogle();
      _me = user;
      emit(AuthLoggedInState(user: user));
    } catch (e) {
      // To Do Create Error State
      emit(AuthNotLoggedInState());
    }
  }

  FutureOr<void> _initiateEmailSignupEvent(
      AuthEmailSignupEvent event, Emitter<AuthState> emit) async {
    try {
      final UserModel user =
          await authRepository.signUpWithEmail(event.newUser, event.password);
      _me = user;
      emit(AuthLoggedInState(user: user));
    } catch (e) {
      // To Do Create Signup Error State
      emit(AuthNotLoggedInState());
    }
  }

  FutureOr<void> _signoutStatusEvent(event, emit) async {
    try {
      await FirebaseAuth.instance.signOut();
      _me = null;
      emit(AuthNotLoggedInState());
    } catch (e) {
      emit(AuthNotSignedOutState());
    }
  }

  FutureOr<void> _getUserUpdatedData(event, emit) async {
    try {
      final UserModel? user = await authRepository.getFirestoreUser(_me!.uid);
      _me = user;
      emit(AuthUserUpdatedState());
    } catch (e) {
      emit(AuthUserNotUpdatedState());
    }
  }
}
