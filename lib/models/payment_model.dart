import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final double amount;
  final Timestamp createdAt;
  final DocumentReference payer;
  final DocumentReference receiver;
  final String? paymentPic;

  PaymentModel({
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
        paymentPic = item['paymentPic'];
}
