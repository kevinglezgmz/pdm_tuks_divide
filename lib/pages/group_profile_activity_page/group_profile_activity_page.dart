import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:intl/date_symbol_data_local.dart';

class GroupProfileActivityPage extends StatelessWidget {
  final dateFormat = DateFormat.MMMM('es');
  GroupProfileActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserActivityBloc, UserActivityState>(
      builder: (context, state) {
        if (state is UserActivityLoadedState) {
          return Stack(
            children: [
              const SizedBox(width: double.infinity, height: double.infinity),
              Container(
                height: 128,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.1,
                      0.4,
                      0.70,
                      1,
                    ],
                    colors: [
                      Colors.yellow,
                      Colors.red,
                      Colors.indigo,
                      Colors.teal,
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 128 - 48,
                  right: 0,
                  left: 0,
                  child: CircleAvatar(
                      radius: 48,
                      backgroundImage: context
                                      .read<AuthBloc>()
                                      .me!
                                      .pictureUrl ==
                                  null ||
                              context.read<AuthBloc>().me!.pictureUrl == ""
                          ? const NetworkImage(
                              "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                          : NetworkImage(
                              context.read<AuthBloc>().me!.pictureUrl!))),
              Positioned(
                top: 128 + 48,
                right: 0,
                left: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      context.read<AuthBloc>().me!.displayName ??
                          context.read<AuthBloc>().me!.fullName ??
                          "<No name>",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Debes \$${_getMyDebt(state.spendingRefs, state.myDebtRefs)}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Te deben \$${_calculateOwing(state.debtRefs, state.spentRefs, state.noDebt)}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 284,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _createActivityList(state.spendingRefs,
                          state.debtRefs, state.spentRefs, state.users),
                    ),
                  ))
            ],
          );
        }
        return Stack(
          children: [
            const SizedBox(width: double.infinity, height: double.infinity),
            Container(
              height: 128,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.1,
                    0.4,
                    0.70,
                    1,
                  ],
                  colors: [
                    Colors.yellow,
                    Colors.red,
                    Colors.indigo,
                    Colors.teal,
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 128 - 48,
              right: 0,
              left: 0,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.indigo,
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 128 + 48,
              right: 0,
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    context.read<AuthBloc>().me!.displayName ??
                        context.read<AuthBloc>().me!.fullName ??
                        "<No name>",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Debe: <No disponible>',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Le deben <No disponible>',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 284,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  ),
                ))
          ],
        );
      },
    );
  }

  double _getMyDebt(
      List<PaymentModel> spendingRefs, List<GroupSpendingModel> myDebtRefs) {
    double total = 0;
    if (myDebtRefs.isEmpty) {
      return total;
    }

    myDebtRefs.forEach((debt) {
      total += debt.amountToPay;
    });

    if (spendingRefs.isEmpty) {
      return total;
    }

    spendingRefs.forEach((spending) {
      total -= spending.amount;
    });

    return total;
  }

  double _calculateOwing(List<PaymentModel> debtRefs,
      List<SpendingModel> spentRefs, List<GroupSpendingModel> noDebt) {
    double total = 0;
    if (spentRefs.isEmpty) {
      return 0;
    }
    spentRefs.forEach((spending) {
      total += spending.amount;
    });
    if (debtRefs.isNotEmpty) {
      debtRefs.forEach((debt) {
        total -= debt.amount;
      });
    }
    if (noDebt.isNotEmpty) {
      noDebt.forEach((notAdebt) {
        total -= notAdebt.amountToPay;
      });
    }
    return total;
  }

  List<Widget> _createActivityList(
      List<PaymentModel> spendingRefs,
      List<PaymentModel> debtRefs,
      List<SpendingModel> spentRefs,
      List<UserModel> users) {
    List<Widget> activityList = [];
    int totalActivityItems =
        debtRefs.length + debtRefs.length + spentRefs.length;
    int paymentIdx = 0;
    int debtIdx = 0;
    int spentIdx = 0;
    DateTime currMonth = DateTime.now();

    activityList.add(const SizedBox(height: 16));

    for (int item = 0; item < totalActivityItems; item++) {
      UserModel? user;
      String title = "";
      String subtitle = "";
      dynamic activity = _getLatestActivity(
          spendingRefs.isNotEmpty ? spendingRefs[paymentIdx] : null,
          debtRefs.isNotEmpty ? debtRefs[debtIdx] : null,
          spentRefs.isNotEmpty ? spentRefs[spentIdx] : null);

      if (activity.createdAt.toDate().month != currMonth.month || item == 0) {
        currMonth = activity.createdAt.toDate();
        activityList.add(_getActivityDateDivider(
            dateFormat.format(currMonth), currMonth.year));
      }

      title = activity.description;
      if (spendingRefs.isNotEmpty && activity == spendingRefs[paymentIdx]) {
        user = users.firstWhere(
            (user) => user.uid == spendingRefs[paymentIdx].receiver.id);
        subtitle = "Pagaste ${activity.amount} a ${user.displayName}";
        paymentIdx++;
      } else if (debtRefs.isNotEmpty && activity == debtRefs[debtIdx]) {
        user = users
            .firstWhere((user) => user.uid == debtRefs[paymentIdx].payer.id);
        subtitle = "${user.displayName} te pagó ${activity.amount}";
        debtIdx++;
      } else {
        subtitle = "Pagaste la cuenta de ${activity.amount}";
        spentIdx++;
      }
      activityList.add(_getActivityTile(
          title, subtitle, dateFormat.format(currMonth), currMonth.day));
    }
    return activityList;
  }

  dynamic _getLatestActivity(
      PaymentModel? payment, PaymentModel? debt, SpendingModel? spending) {
    if (payment == null && debt == null) {
      return spending;
    } else if (payment == null && spending == null) {
      return debt;
    } else if (debt == null && spending == null) {
      return payment;
    } else if (payment == null &&
        debt!.createdAt.millisecondsSinceEpoch >
            spending!.createdAt.millisecondsSinceEpoch) {
      return debt;
    } else if (payment == null &&
        debt!.createdAt.millisecondsSinceEpoch <
            spending!.createdAt.millisecondsSinceEpoch) {
      return debt;
    } else if (debt == null &&
        payment!.createdAt.millisecondsSinceEpoch >
            spending!.createdAt.millisecondsSinceEpoch) {
      return payment;
    } else if (debt == null &&
        payment!.createdAt.millisecondsSinceEpoch <
            spending!.createdAt.millisecondsSinceEpoch) {
      return spending;
    } else if (spending == null &&
        payment!.createdAt.millisecondsSinceEpoch >
            debt!.createdAt.millisecondsSinceEpoch) {
      return payment;
    } else if (spending == null &&
        payment!.createdAt.millisecondsSinceEpoch <
            debt!.createdAt.millisecondsSinceEpoch) {
      return debt;
    } else if (payment!.createdAt.millisecondsSinceEpoch >
            debt!.createdAt.millisecondsSinceEpoch &&
        payment.createdAt.millisecondsSinceEpoch >
            spending!.createdAt.millisecondsSinceEpoch) {
      return payment;
    } else if (debt.createdAt.millisecondsSinceEpoch >
        spending!.createdAt.millisecondsSinceEpoch) {
      return debt;
    }
    return spending;
  }

  Widget _getActivityDateDivider(String month, int year) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Text(
        '${month[0].toUpperCase() + month.substring(1)} del $year',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getActivityTile(
      String title, String subtitle, String month, int day) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${month.substring(0, 3)}.',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Text(
                '$day',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        minLeadingWidth: 28,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.attach_money),
      ),
    );
  }
}
