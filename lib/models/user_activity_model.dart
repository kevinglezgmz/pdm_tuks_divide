import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class UserActivityModel extends Equatable {
  final List<PaymentModel> spendingRefs;
  final List<PaymentModel> debtRefs;
  final List<SpendingModel> spentRefs;
  final List<UserModel> otherUsers;
  final List<GroupSpendingModel> notDebt;
  final List<GroupSpendingModel> owingRefs;
  final List<GroupSpendingModel> myDebtRefs;

  const UserActivityModel(
      {required this.spendingRefs,
      required this.debtRefs,
      required this.spentRefs,
      required this.otherUsers,
      required this.notDebt,
      required this.owingRefs,
      required this.myDebtRefs});

  @override
  List<Object?> get props => [
        spendingRefs,
        debtRefs,
        spentRefs,
        otherUsers,
        notDebt,
        owingRefs,
        myDebtRefs
      ];

  UserActivityModel.fromMap(Map<String, dynamic> item)
      : spendingRefs = item['spendingRefs'],
        debtRefs = item['debtRefs'],
        spentRefs = item['spentRefs'],
        otherUsers = item['otherUsers'],
        notDebt = item['otherUsers'],
        owingRefs = item['owingRefs'],
        myDebtRefs = item['myDebtRefs'];
}
