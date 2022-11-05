import 'package:cloud_firestore/cloud_firestore.dart';

class GroupsUsersModel {
  final DocumentReference<Map<String, dynamic>> group;
  final DocumentReference<Map<String, dynamic>> user;

  GroupsUsersModel({
    required this.group,
    required this.user,
  });

  GroupsUsersModel.fromMap(Map<String, dynamic> item)
      : group = item['group'],
        user = item['user'];
}
