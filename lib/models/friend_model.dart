import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FriendModel extends Equatable {
  final Timestamp friendedAt;
  final DocumentReference<Map<String, dynamic>> userA;
  final DocumentReference<Map<String, dynamic>> userB;

  const FriendModel({
    required this.friendedAt,
    required this.userA,
    required this.userB,
  });

  FriendModel.fromMap(Map<String, dynamic> item)
      : friendedAt = item['friendedAt'],
        userA = item['userA'],
        userB = item['userB'];

  @override
  List<Object?> get props => [
        friendedAt.toString(),
        userA.id,
        userB.id,
      ];
}
