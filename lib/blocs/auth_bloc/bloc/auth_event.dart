part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckLoginStatusEvent extends AuthEvent {}

class AuthEmailLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthEmailLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthGoogleLoginEvent extends AuthEvent {}

class AuthEmailSignupEvent extends AuthEvent {
  final UserDetails newUser;
  final String password;

  const AuthEmailSignupEvent({required this.newUser, required this.password});

  @override
  List<Object> get props => [newUser, password];
}
