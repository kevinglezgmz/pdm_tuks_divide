import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String? pictureUrl;
  final String? firstName;
  final String? lastName;
  final String? displayName;

  const UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.firstName,
    this.lastName,
    this.pictureUrl,
  });

  UserModel.fromMap(Map<String, dynamic> item)
      : displayName = item['displayName'] == "" ? null : item['displayName'],
        email = item['email'],
        firstName = item['firstName'],
        lastName = item['lastName'],
        pictureUrl = item['pictureUrl'],
        uid = item['uid'];

  String? get fullName {
    if (firstName != null &&
        firstName != "" &&
        lastName != null &&
        lastName != "") {
      return "${firstName!} ${lastName!}";
    }
    return null;
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        pictureUrl,
        firstName,
        lastName,
        displayName,
      ];
}
