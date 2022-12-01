import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GroupModel extends Equatable {
  final Timestamp createdAt;
  final String description;
  final String groupName;
  final String groupPicUrl;
  final DocumentReference<Map<String, dynamic>> owner;
  final String groupId;

  const GroupModel({
    required this.createdAt,
    required this.description,
    required this.groupName,
    required this.owner,
    required this.groupPicUrl,
    required this.groupId,
  });

  GroupModel.fromMap(Map<String, dynamic> item)
      : createdAt = item['createdAt'],
        description = item['description'],
        groupName = item['groupName'],
        owner = item['owner'],
        groupId = item['groupId'],
        groupPicUrl = item['groupPicUrl'] ?? '';

  @override
  List<Object?> get props => [
        createdAt.toString(),
        description,
        groupName,
        owner.id,
        groupId,
        groupPicUrl,
      ];
}
