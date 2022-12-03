import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class UserActivityModel extends Equatable {
  final List<PaymentModel> myPayments;
  final List<PaymentModel> payback;
  final List<SpendingModel> spendingDoneByMe;
  final List<UserModel> otherUsers;
  final List<GroupSpendingModel> myDebts;
  final List<GroupSpendingModel> owings;

  const UserActivityModel(
      {required this.myPayments,
      required this.payback,
      required this.spendingDoneByMe,
      required this.otherUsers,
      required this.myDebts,
      required this.owings});

  @override
  List<Object?> get props => [
        myPayments,
        payback,
        spendingDoneByMe,
        otherUsers,
        myDebts,
        owings,
      ];

  UserActivityModel.fromMap(Map<String, dynamic> item)
      : myPayments = item['myPayments'],
        payback = item['payback'],
        spendingDoneByMe = item['spendingDoneByMe'],
        otherUsers = item['otherUsers'],
        myDebts = item['otherUsers'],
        owings = item['owings'];
}
