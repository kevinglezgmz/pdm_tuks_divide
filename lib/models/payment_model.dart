import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final double amount;
  final Timestamp createdAt;
  final DocumentReference payer;
  final DocumentReference receiver;
  final DocumentReference groupSpending;
  final String? paymentPic;

  PaymentModel(
    this.groupSpending, {
    required this.amount,
    required this.createdAt,
    required this.payer,
    required this.receiver,
    required this.paymentPic,
  });

  PaymentModel.fromMap(Map<String, dynamic> item)
      : amount = item['amount'],
        createdAt = item['createdAt'],
        payer = item['payer'],
        receiver = item['receiver'],
        groupSpending = item['groupSpending'],
        paymentPic = item['paymentPic'];
}
