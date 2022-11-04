import 'package:cloud_firestore/cloud_firestore.dart';

enum DistributionType {
  equal,
  unequal,
  percentage,
}

class SpendingModel {
  final double amount;
  final Timestamp createdAt;
  final String description;
  final DistributionType distributionType;
  final DocumentReference paidBy;
  final DocumentReference addedBy;
  final List<DocumentReference> participants;
  final String? spendingPic;

  SpendingModel({
    required this.amount,
    required this.createdAt,
    required this.description,
    required this.distributionType,
    required this.paidBy,
    required this.participants,
    required this.spendingPic,
    required this.addedBy,
  });

  SpendingModel.fromMap(Map<String, dynamic> item)
      : amount = item['amount'],
        createdAt = item['createdAt'],
        addedBy = item['addedBy'],
        description = item['description'],
        distributionType = item['distributionType'],
        paidBy = item['paidBy'],
        participants = item['participants'],
        spendingPic = item['spendingPic'];
}
