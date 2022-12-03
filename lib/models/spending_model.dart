import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum DistributionType {
  equal,
  unequal,
  percentage,
}

class SpendingModel extends Equatable {
  final double amount;
  final Timestamp createdAt;
  final String description;
  final DistributionType distributionType;
  final DocumentReference<Map<String, dynamic>> paidBy;
  final DocumentReference<Map<String, dynamic>> addedBy;
  final List<DocumentReference<Map<String, dynamic>>> participants;
  final String? spendingPic;
  final String spendingId;

  const SpendingModel({
    required this.amount,
    required this.createdAt,
    required this.description,
    required this.distributionType,
    required this.paidBy,
    required this.participants,
    required this.spendingPic,
    required this.addedBy,
    required this.spendingId,
  });

  SpendingModel.fromMap(Map<String, dynamic> item)
      : amount = item['amount'],
        createdAt = item['createdAt'],
        addedBy = item['addedBy'],
        description = item['description'],
        distributionType = DistributionType.values[item['distributionType']],
        paidBy = item['paidBy'],
        participants = List<DocumentReference<Map<String, dynamic>>>.from(
            item['participants']),
        spendingId = item['spendingId'],
        spendingPic = item['spendingPic'];

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'createdAt': createdAt,
      'description': description,
      'distributionType': distributionType.index,
      'paidBy': paidBy,
      'participants': participants,
      'spendingPic': spendingPic,
      'addedBy': addedBy,
    };
  }

  static String distributionTypeText(DistributionType distributionType) {
    if (distributionType == DistributionType.equal) {
      return 'partes iguales';
    } else if (distributionType == DistributionType.unequal) {
      return 'partes desiguales';
    } else {
      return 'porcentajes';
    }
  }

  @override
  List<Object?> get props => [
        amount,
        createdAt,
        description,
        distributionType,
        paidBy,
        addedBy,
        participants.toString(),
        spendingPic,
      ];
}
