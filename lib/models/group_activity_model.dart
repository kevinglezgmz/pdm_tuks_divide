import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class GroupActivityModel extends Equatable {
  final List<PaymentModel> payments;
  final List<SpendingModel> spendings;
  final List<UserModel> groupUsers;

  const GroupActivityModel(
      {required this.payments,
      required this.spendings,
      required this.groupUsers});

  GroupActivityModel.fromMap(Map<String, dynamic> item)
      : payments = item['payments'],
        spendings = item['spendings'],
        groupUsers = item['groupUsers'];

  @override
  List<Object?> get props => [
        payments,
        spendings,
        groupUsers,
      ];
}
