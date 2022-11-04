import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final Timestamp createdAt;
  final String description;
  final String groupName;
  final DocumentReference ownerId;
  final String? groupPicUrl;

  GroupModel({
    required this.createdAt,
    required this.description,
    required this.groupName,
    required this.ownerId,
    required this.groupPicUrl,
  });

  GroupModel.fromMap(Map<String, dynamic> item)
      : createdAt = item['createdAt'],
        description = item['description'],
        groupName = item['groupName'],
        ownerId = item['ownerId'],
        groupPicUrl = item['groupPicUrl'];
}
