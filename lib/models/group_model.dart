import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final Timestamp createdAt;
  final String description;
  final String groupName;
  final DocumentReference<Map<String, dynamic>>? owner;
  final String? groupPicUrl;

  GroupModel({
    required this.createdAt,
    required this.description,
    required this.groupName,
    required this.owner,
    required this.groupPicUrl,
  });

  GroupModel.fromMap(Map<String, dynamic> item)
      : createdAt = item['createdAt'],
        description = item['description'],
        groupName = item['groupName'],
        owner = item['owner'],
        groupPicUrl = item['groupPicUrl'];
}
