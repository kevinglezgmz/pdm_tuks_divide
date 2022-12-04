import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';

class GroupActivityModel extends Equatable {
  final List<PaymentModel> payments;
  final List<SpendingModel> spendings;

  const GroupActivityModel({
    required this.payments,
    required this.spendings,
  });

  GroupActivityModel.fromMap(Map<String, dynamic> item)
      : payments = item['payments'],
        spendings = item['spendings'];

  @override
  List<Object?> get props => [
        payments,
        spendings,
      ];
}
