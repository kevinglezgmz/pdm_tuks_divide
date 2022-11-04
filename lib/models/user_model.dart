class UserModel {
  final String uid;
  final String email;
  final String? pictureUrl;
  final String? firstName;
  final String? lastName;
  final String? displayName;

  UserModel({
    required this.displayName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.pictureUrl,
    required this.uid,
  });

  UserModel.fromMap(Map<String, dynamic> item)
      : displayName = item['displayName'],
        email = item['email'],
        firstName = item['firstName'],
        lastName = item['lastName'],
        pictureUrl = item['pictureUrl'],
        uid = item['uid'];
}
