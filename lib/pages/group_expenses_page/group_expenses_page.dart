import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/payment_detail_bloc/bloc/payment_detail_bloc.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_bloc.dart';
import 'package:tuks_divide/blocs/spendings_bloc/bloc/spendings_bloc.dart';
import 'package:tuks_divide/components/avatar_widget.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/add_spending_page/add_spending_page.dart';
import 'package:intl/intl.dart';
import 'package:tuks_divide/pages/payment_detail_page/payment_detail_page.dart';
import 'package:tuks_divide/pages/spending_detail_page/spending_detail_page.dart';

class GroupExpensesPage extends StatelessWidget {
  final GroupModel group;
  final dateFormat = DateFormat.MMMM('es');
  GroupExpensesPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsUseState>(builder: (context, state) {
      return Scaffold(
        body: Column(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                color: Colors.cyan[200],
                height: MediaQuery.of(context).size.height / 6,
              ),
              Positioned(
                left: 30,
                bottom: -40,
                child: AvatarWidget(
                  backgroundColor: Colors.pink[100],
                  radius: 50,
                  iconSize: 50,
                  avatarUrl: group.groupPicUrl,
                ),
              ),
            ]),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                group.groupName,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      //TODO: GET DEBTS AND OWINGS
                      Text(
                        "Juan Pérez te debe ",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text("\$65.32",
                          style: TextStyle(fontSize: 16, color: Colors.blue))
                    ],
                  ),
                  Row(
                    children: const [
                      Text("Debes a Andrea ",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text("\$150.36",
                          style: TextStyle(fontSize: 16, color: Colors.blue))
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: state.isLoadingActivity
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: _createActivityList(state.spendings,
                            state.payments, state.groupUsers, context),
                      ),
                    ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'Add Expense To Group',
          onPressed: () {
            BlocProvider.of<SpendingsBloc>(context).add(
              SpendingsResetBlocEvent(),
            );
            Navigator.of(context)
                .push(
                  MaterialPageRoute(
                    builder: (context) => const AddSpendingPage(),
                  ),
                )
                .then(
                  (value) => BlocProvider.of<SpendingsBloc>(context).add(
                    SpendingsResetBlocEvent(),
                  ),
                );
          },
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
      );
    }, listener: (context, state) {
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.errorMessage,
            ),
          ),
        );
      }
    });
  }

  List<Widget> _createActivityList(List<SpendingModel> spendings,
      List<PaymentModel> payments, List<UserModel> users, context) {
    List<Widget> activityList = [];
    int totalActivityItems = payments.length + spendings.length;
    int spendingIdx = 0;
    int paymentsIdx = 0;
    DateTime currMonth = DateTime.now();

    if (spendings.isEmpty && payments.isEmpty) {
      activityList.add(const Text("No hay actividad para mostrar"));
      return activityList;
    }

    activityList.add(const SizedBox(height: 16));

    for (int item = 0; item < totalActivityItems; item++) {
      String title = "";
      String subtitle = "";
      VoidCallback onTap = () {};
      dynamic activity = _getLatestActivity(
          payments.isNotEmpty ? payments[paymentsIdx] : null,
          spendings.isNotEmpty ? spendings[spendingIdx] : null);

      if (activity.createdAt.toDate().month != currMonth.month || item == 0) {
        currMonth = activity.createdAt.toDate();
        activityList.add(_getActivityDateDivider(
            dateFormat.format(currMonth), currMonth.year));
      }

      title = activity.description;
      if (spendings.isNotEmpty && activity == spendings[spendingIdx]) {
        final user = users
            .firstWhere((user) => user.uid == spendings[spendingIdx].paidBy.id);
        subtitle = "${user.displayName} pagó ${activity.amount}";
        onTap = () {
          BlocProvider.of<SpendingDetailBloc>(context)
              .add(GetSpendingDetailEvent(spending: activity));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpendingDetailPage(),
            ),
          );
        };
        spendingIdx++;
      } else if (payments.isNotEmpty && activity == payments[paymentsIdx]) {
        final payer = users
            .firstWhere((user) => user.uid == payments[spendingIdx].payer.id);
        final receiver = users.firstWhere(
            (user) => user.uid == payments[spendingIdx].receiver.id);
        subtitle =
            "${payer.displayName} pagó a ${receiver.displayName} ${activity.amount}";
        onTap = () {
          BlocProvider.of<PaymentDetailBloc>(context)
              .add(GetPaymentDetailEvent(payment: activity));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaymentDetailPage(),
            ),
          );
        };
        paymentsIdx++;
      }
      activityList.add(_getActivityTile(
          title, subtitle, dateFormat.format(currMonth), currMonth.day, onTap));
    }
    return activityList;
  }

  dynamic _getLatestActivity(PaymentModel? payment, SpendingModel? spending) {
    if (payment == null) {
      return spending;
    } else if (spending == null) {
      return payment;
    } else if (payment.createdAt.millisecondsSinceEpoch >
        spending.createdAt.millisecondsSinceEpoch) {
      return payment;
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

  Widget _getActivityTile(String title, String subtitle, String month, int day,
      VoidCallback onTap) {
    return Card(
        child: InkWell(
      onTap: onTap,
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
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        minLeadingWidth: 28,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const FaIcon(FontAwesomeIcons.receipt),
      ),
    ));
  }
}
