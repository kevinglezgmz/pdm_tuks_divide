part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthNotLoggedInState extends AuthState {}

class AuthLoggingInState extends AuthState {}

class AuthLoggedInState extends AuthState {
  final UserModel user;
  const AuthLoggedInState({required this.user});

  @override
  List<Object> get props => [user];
}
