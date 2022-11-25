part of 'update_user_profile_bloc.dart';

abstract class UpdateUserProfileEvent extends Equatable {
  const UpdateUserProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateNewUserProfileInfoEvent extends UpdateUserProfileEvent {
  final String uid;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String displayName;

  const UpdateNewUserProfileInfoEvent(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.imageUrl,
      required this.displayName});

  @override
  List<Object> get props => [firstName, lastName, imageUrl, displayName];
}
