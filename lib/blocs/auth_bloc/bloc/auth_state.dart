part of 'auth_bloc.dart';

class UserDetails {
  final String uid;
  final String? pictureUrl;
  final String? email;
  final String? displayName;

  UserDetails({
    required this.uid,
    required this.pictureUrl,
    required this.email,
    required this.displayName,
  });
}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthNotLoggedInState extends AuthState {}

class AuthLoggingInState extends AuthState {}

class AuthLoggedInState extends AuthState {
  final UserDetails user;
  const AuthLoggedInState({required this.user});

  @override
  List<Object> get props => [user];
}
