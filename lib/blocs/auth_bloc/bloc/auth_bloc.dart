import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthNotLoggedInState()) {
    on<AuthPasswordLoginEvent>(_initiatePasswordLoginEvent);
    on<AuthGoogleLoginEvent>(_initiateGoogleLoginEvent);
    on<AuthCheckLoginStatusEvent>(((event, emit) {
      // To Do: Check if user is already logged in when opening the app after close
    }));
  }

  FutureOr<void> _initiatePasswordLoginEvent(
      AuthPasswordLoginEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> _initiateGoogleLoginEvent(
      AuthGoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoggingInState());
    try {
      final UserDetails? user = await authRepository.signInWithGoogle();
      emit(AuthLoggedInState(user: user!));
    } catch (e) {
      // To Do Create Error State
      emit(AuthNotLoggedInState());
    }
  }
}
