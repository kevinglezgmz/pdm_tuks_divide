part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckLoginStatusEvent extends AuthEvent {}

class AuthPasswordLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthPasswordLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthGoogleLoginEvent extends AuthEvent {}
