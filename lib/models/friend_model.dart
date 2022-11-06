import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  final Timestamp friendedAt;
  final DocumentReference<Map<String, dynamic>> userA;
  final DocumentReference<Map<String, dynamic>> userB;

  FriendModel({
    required this.friendedAt,
    required this.userA,
    required this.userB,
  });

  FriendModel.fromMap(Map<String, dynamic> item)
      : friendedAt = item['friendedAt'],
        userA = item['userA'],
        userB = item['userB'];
}
