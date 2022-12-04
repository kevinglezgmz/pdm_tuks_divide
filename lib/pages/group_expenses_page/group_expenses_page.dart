import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/participants_detail_bloc/bloc/participants_detail_bloc.dart';
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
import 'package:tuks_divide/pages/group_expenses_page/expandable_fab.dart';
import 'package:tuks_divide/pages/group_participants_detail_page/group_participants_detail_page.dart';
import 'package:tuks_divide/pages/pay_debt_page/pay_debt_page.dart';
import 'package:tuks_divide/pages/payment_detail_page/payment_detail_page.dart';
import 'package:tuks_divide/pages/spending_detail_page/spending_detail_page.dart';

class GroupExpensesPage extends StatefulWidget {
  final GroupModel group;

  const GroupExpensesPage({super.key, required this.group});

  @override
  State<GroupExpensesPage> createState() => _GroupExpensesPageState();
}

class _GroupExpensesPageState extends State<GroupExpensesPage> {
  final dateFormat = DateFormat.MMMM('es');
  late final SpendingsBloc spendingsBloc;
  late final AuthBloc authBloc;

  @override
  void initState() {
    spendingsBloc = BlocProvider.of<SpendingsBloc>(context);
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsUseState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalles de grupo"),
          actions: [
            IconButton(
                onPressed: () {
                  BlocProvider.of<ParticipantsDetailBloc>(context).add(
                      GetParticipantsDetailEvent(
                          groupId: widget.group.groupId));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GroupParticipantsDetailPage(),
                    ),
                  );
                },
                icon: const FaIcon(FontAwesomeIcons.peopleGroup))
          ],
        ),
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
                  avatarUrl: widget.group.groupPicUrl,
                ),
              ),
            ]),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.group.groupName,
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
        floatingActionButton: ExpandableFab(
          distance: 80.0,
          children: [
            ActionButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SelectPayeeSearchDelegate(),
                ).then(
                  (selectedUser) {
                    if (selectedUser != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PayDebtPage(
                            sender: authBloc.me!,
                            receiver: selectedUser,
                            group: widget.group,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
              icon: const Icon(Icons.payments_outlined),
              message: "Añadir un pago",
            ),
            ActionButton(
              onPressed: () {
                spendingsBloc.add(SpendingsResetBlocEvent());
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const AddSpendingPage(),
                      ),
                    )
                    .then(
                      (value) => spendingsBloc.add(SpendingsResetBlocEvent()),
                    );
              },
              icon: const Icon(Icons.post_add_sharp),
              message: "Añadir un gasto",
            ),
          ],
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
          payments.isNotEmpty && paymentsIdx < payments.length
              ? payments[paymentsIdx]
              : null,
          spendings.isNotEmpty && spendingIdx < spendings.length
              ? spendings[spendingIdx]
              : null);

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

class SelectPayeeSearchDelegate extends SearchDelegate<UserModel?> {
  SelectPayeeSearchDelegate() : super(searchFieldLabel: "Pago hecho a...");

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<UserModel> queryResult = getResults(context);
    return ListView.builder(
      itemCount: queryResult.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const SizedBox(height: 16);
        }
        UserModel user = queryResult[index - 1];
        return getUserTile(context, user);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<UserModel> queryResult = getResults(context);
    queryResult = queryResult.sublist(
      0,
      queryResult.length > 10 ? 10 : queryResult.length,
    );
    return ListView.builder(
      itemCount: queryResult.length,
      itemBuilder: (BuildContext context, int index) {
        UserModel user = queryResult[index];
        return getUserTile(context, user);
      },
    );
  }

  List<UserModel> getResults(BuildContext context) {
    UserModel me = BlocProvider.of<AuthBloc>(context).me!;
    List<UserModel> membersInGroup = BlocProvider.of<SpendingsBloc>(context)
        .usersInGroup
        .where((element) => element != me)
        .toList();
    String queryLC = query.toLowerCase();
    return queryLC == ""
        ? membersInGroup
        : membersInGroup
            .where(
              (element) =>
                  ((element.displayName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0) ||
                  ((element.firstName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0) ||
                  ((element.lastName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0),
            )
            .toList();
  }

  Widget getUserTile(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: InkWell(
          onTap: () {
            close(context, user);
          },
          child: ListTile(
            title: Text(user.displayName ?? user.fullName ?? '<Sin Nombre>'),
            leading: CircleAvatar(
              backgroundImage: user.pictureUrl == null || user.pictureUrl == ""
                  ? const NetworkImage(
                      "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                    )
                  : NetworkImage(user.pictureUrl!),
            ),
          ),
        ),
      ),
    );
  }
}
