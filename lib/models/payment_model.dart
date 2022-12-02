import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final double amount;
  final Timestamp createdAt;
  final String description;
  final DocumentReference<Map<String, dynamic>> payer;
  final DocumentReference<Map<String, dynamic>> receiver;
  final DocumentReference<Map<String, dynamic>> groupSpending;
  final String? paymentPic;

  PaymentModel(
    this.groupSpending, {
    required this.amount,
    required this.createdAt,
    required this.description,
    required this.payer,
    required this.receiver,
    required this.paymentPic,
  });

  PaymentModel.fromMap(Map<String, dynamic> item)
      : amount = item['amount'],
        createdAt = item['createdAt'],
        description = item['description'],
        payer = item['payer'],
        receiver = item['receiver'],
        groupSpending = item['groupSpending'],
        paymentPic = item['paymentPic'];
}
