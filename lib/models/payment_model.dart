import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final double amount;
  final Timestamp createdAt;
  final String description;
  final DocumentReference<Map<String, dynamic>> payer;
  final DocumentReference<Map<String, dynamic>> receiver;
  final DocumentReference<Map<String, dynamic>> groupSpending;
  final String? paymentPic;

  const PaymentModel(
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

  @override
  List<Object?> get props => [
        amount,
        createdAt,
        description,
        payer.id,
        receiver.id,
        groupSpending.id,
        paymentPic ?? "paymentPic",
      ];
}
