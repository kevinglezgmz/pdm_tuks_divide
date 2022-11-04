import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSpendingModel {
  final DocumentReference groupId;
  final DocumentReference spendingId;

  GroupSpendingModel({
    required this.groupId,
    required this.spendingId,
  });

  GroupSpendingModel.fromMap(Map<String, dynamic> item)
      : groupId = item['groupId'],
        spendingId = item['spendingId'];
}
