part of 'auth_bloc.dart';

class UserDetails {
  final String uid;
  final String email;
  final String? pictureUrl;
  final String? firstName;
  final String? lastName;
  final String? displayName;

  UserDetails({
    required this.uid,
    required this.pictureUrl,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.displayName,
  });

  UserDetails.fromMap(Map<String, dynamic> userMap)
      : uid = userMap['uid'],
        displayName = userMap['displayName'],
        email = userMap['email'],
        lastName = userMap['lastName'],
        firstName = userMap['firstName'],
        pictureUrl = userMap['pictureUrl'];
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
