import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

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
                  child: Center(
                    child: CircleAvatar(
                        radius: 55,
                        backgroundImage: context
                                        .read<AuthBloc>()
                                        .me!
                                        .pictureUrl ==
                                    null ||
                                context.read<AuthBloc>().me!.pictureUrl == ""
                            ? const NetworkImage(
                                "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                            : NetworkImage(
                                context.read<AuthBloc>().me!.pictureUrl!)),
                  )),
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
                      "Debes \$${_getMyDebt(state.myPayments, state.myDebts, context.read<AuthBloc>().me!.uid)}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Te deben \$${_calculateOwing(state.owings, context.read<AuthBloc>().me!.uid)}',
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
                      children: _createActivityList(
                          state.myPayments,
                          state.payback,
                          state.spendingDoneByMe,
                          state.owings,
                          state.otherUsers,
                          context.read<AuthBloc>().me!),
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

  double _getMyDebt(List<PaymentModel> myPayments,
      List<GroupSpendingModel> myDebts, String uid) {
    double total = 0;
    if (myDebts.isEmpty) {
      return total;
    }

    for (var debt in myDebts) {
      if (debt.user.id != uid) {
        total += debt.amountToPay;
      }
    }

    if (myPayments.isEmpty) {
      return total;
    }

    for (var payment in myPayments) {
      total -= payment.amount;
    }

    return total;
  }

  double _calculateOwing(List<GroupSpendingModel> owings, String uid) {
    double total = 0;
    if (owings.isEmpty) {
      return total;
    }
    for (var owing in owings) {
      if (owing.user.id != uid) {
        total += owing.amountToPay;
      }
    }
    return total;
  }

  List<Widget> _createActivityList(
      List<PaymentModel> myPayments,
      List<PaymentModel> payback,
      List<SpendingModel> spendingDoneByMe,
      List<GroupSpendingModel> owings,
      List<UserModel> users,
      UserModel me) {
    List<SpendingModel> pastSpendings = [];
    List<Widget> activityList = [];
    int totalActivityItems = payback.length +
        payback.length +
        spendingDoneByMe.length +
        owings.length;

    activityList.add(const SizedBox(height: 16));
    if (totalActivityItems == 0) {
      activityList.add(const Text(
        "No hay actividad para mostrar",
        textAlign: TextAlign.center,
      ));
      return activityList;
    }

    DateTime currMonth = DateTime.now();

    for (int item = 0; item < totalActivityItems; item++) {
      UserModel? user;
      String title = "";
      String subtitle = "";
      Timestamp? owingsDate;
      if (owings.isNotEmpty) {
        final currSpending = spendingDoneByMe
            .where((element) => owings[0].spending.id == element.spendingId)
            .toList();
        owingsDate = currSpending.isNotEmpty ? currSpending[0].createdAt : null;
        if (owingsDate == null) {
          final pastSpending = pastSpendings
              .where((element) => owings[0].spending.id == element.spendingId)
              .toList();
          owingsDate =
              pastSpending.isNotEmpty ? pastSpending[0].createdAt : null;
        }
      }
      dynamic activity = _getLatestActivity(
          myPayments.isNotEmpty ? myPayments[0] : null,
          payback.isNotEmpty ? payback[0] : null,
          spendingDoneByMe.isNotEmpty ? spendingDoneByMe[0] : null,
          owings.isNotEmpty ? owings[0] : null,
          owingsDate?.millisecondsSinceEpoch);

      if (activity == owings[0]) {
        title = "Nueva deuda";
        if (owingsDate!.toDate().month != currMonth.month) {
          currMonth = owingsDate.toDate();
          activityList.add(_getActivityDateDivider(
              dateFormat.format(currMonth), currMonth.year));
        }
      } else if (activity != owings[0]) {
        title = activity.description;
        if (activity.createdAt.toDate().month != currMonth.month || item == 0) {
          currMonth = activity.createdAt.toDate();
          activityList.add(_getActivityDateDivider(
              dateFormat.format(currMonth), currMonth.year));
        }
      }

      if (myPayments.isNotEmpty && activity == myPayments[0]) {
        user =
            users.firstWhere((user) => user.uid == myPayments[0].receiver.id);
        subtitle = "Pagaste ${activity.amount} a ${user.displayName}";
        myPayments.removeAt(0);
      } else if (payback.isNotEmpty && activity == payback[0]) {
        user = users.firstWhere((user) => user.uid == payback[0].payer.id);
        subtitle = "${user.displayName} te pagó ${activity.amount}";
        payback.removeAt(0);
      } else if (spendingDoneByMe.isNotEmpty &&
          activity == spendingDoneByMe[0]) {
        subtitle = "Pagaste la cuenta de ${activity.amount}";
        pastSpendings.add(spendingDoneByMe.removeAt(0));
      } else if (activity != null) {
        user = users.firstWhere((user) => user.uid == owings[0].user.id);
        subtitle =
            "${user.displayName} debe a ${me.displayName} \$${activity.amountToPay}";
        owings.removeAt(0);
      }
      activityList.add(_getActivityTile(
          title, subtitle, dateFormat.format(currMonth), currMonth.day));
    }
    return activityList;
  }

  dynamic _getLatestActivity(PaymentModel? payment, PaymentModel? payback,
      SpendingModel? spending, GroupSpendingModel? owing, int? owingsDate) {
    int minIdx = 0;
    final List<int?> milis = [];
    milis.add(payment?.createdAt.millisecondsSinceEpoch);
    milis.add(payback?.createdAt.millisecondsSinceEpoch);
    milis.add(spending?.createdAt.millisecondsSinceEpoch);
    milis.add(owingsDate);
    for (int i = 1; i < 4; i++) {
      if (milis[i - 1] == null) {
        minIdx = i;
        continue;
      }
      if (milis[i] != null &&
          milis[minIdx] != null &&
          milis[i]! > milis[minIdx]!) {
        minIdx = i;
      }
    }
    if (minIdx == 0) {
      return payment;
    } else if (minIdx == 1) {
      return payback;
    } else if (minIdx == 2) {
      return spending;
    }
    return owing;
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
