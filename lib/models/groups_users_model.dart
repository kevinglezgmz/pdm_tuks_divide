import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GroupsUsersModel extends Equatable {
  final DocumentReference<Map<String, dynamic>> group;
  final DocumentReference<Map<String, dynamic>> user;

  const GroupsUsersModel({
    required this.group,
    required this.user,
  });

  GroupsUsersModel.fromMap(Map<String, dynamic> item)
      : group = item['group'],
        user = item['user'];

  @override
  List<Object?> get props => [
        group.id,
        user.id,
      ];
}
