import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GroupSpendingModel extends Equatable {
  final DocumentReference group;
  final DocumentReference spending;
  final DocumentReference user;
  final double amountToPay;

  const GroupSpendingModel({
    required this.group,
    required this.spending,
    required this.user,
    required this.amountToPay,
  });

  GroupSpendingModel.fromMap(Map<String, dynamic> item)
      : group = item['group'],
        user = item['user'],
        amountToPay = item['amountToPay'],
        spending = item['spending'];

  Map<String, dynamic> toMap() => {
        'group': group,
        'spending': spending,
        'user': user,
        'amountToPay': amountToPay,
      };

  @override
  List<Object?> get props => [
        group.id,
        spending.id,
        user.id,
        amountToPay,
      ];
}
