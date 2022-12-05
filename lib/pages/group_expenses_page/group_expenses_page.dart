import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_bloc.dart';
import 'package:tuks_divide/blocs/spendings_bloc/bloc/spendings_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/components/avatar_widget.dart';
import 'package:tuks_divide/models/group_activity_model.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/add_spending_page/add_spending_page.dart';
import 'package:intl/intl.dart';
import 'package:tuks_divide/pages/group_expenses_page/expandable_fab.dart';
import 'package:tuks_divide/pages/group_graph_page/group_graph_page.dart';
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
  late final StreamSubscription<GroupActivityModel>
      _groupActivityStreamSubscription;
  final dateFormat = DateFormat.MMMM('es');
  late final SpendingsBloc spendingsBloc;
  late final MeBloc meBloc;
  late final GroupsBloc groupsBloc;

  @override
  void initState() {
    spendingsBloc = BlocProvider.of<SpendingsBloc>(context);
    meBloc = BlocProvider.of<MeBloc>(context);
    groupsBloc = BlocProvider.of<GroupsBloc>(context);
    _listenForRealtimeUpdates();
    super.initState();
  }

  @override
  void dispose() {
    _groupActivityStreamSubscription.cancel();
    super.dispose();
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GroupParticipantsDetailPage(
                        usersInGroup: state.groupUsers,
                      ),
                    ),
                  );
                },
                icon: const FaIcon(FontAwesomeIcons.peopleGroup)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GroupGraphPage(),
                    ),
                  );
                },
                icon: const FaIcon(FontAwesomeIcons.chartLine))
          ],
        ),
        body: Column(
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/bg-${Random(widget.group.groupId.hashCode).nextInt(9) + 1}.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                height: MediaQuery.of(context).size.height / 6,
              ),
              Positioned(
                left: 27,
                bottom: -53,
                child: CircleAvatar(
                  radius: 53,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              Positioned(
                left: 30,
                bottom: -50,
                child: AvatarWidget(
                  backgroundColor: Colors.pink[100],
                  radius: 50,
                  iconSize: 50,
                  avatarUrl: widget.group.groupPicUrl,
                ),
              ),
            ]),
            const SizedBox(height: 22),
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
              padding: const EdgeInsets.fromLTRB(20, 4, 0, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Gastos totales del grupo: ",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                          "\$${_getGroupTotalSpendings(state.spendings).toStringAsFixed(2)}",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.blue))
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.isLoadingActivity || state.groupUsers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : state.spendings.isEmpty && state.payments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "No han realizado ningún gasto.",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  spendingsBloc
                                      .add(SpendingsSetInitialSpendingsEvent());
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddSpendingPage(),
                                    ),
                                  )
                                      .then((value) {
                                    BlocProvider.of<UploadImageBloc>(context)
                                        .add(ResetUploadImageBloc());
                                  });
                                },
                                child: const Text(
                                  "Agrega uno!",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 90),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: _createActivityList(
                              state.spendings,
                              state.payments,
                              state.groupUsers,
                              context,
                            ),
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
                      if (selectedUser.user ==
                              BlocProvider.of<MeBloc>(context).state.me &&
                          selectedUser.howMuchDoIOweThem == 0) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                "No tienes ningún saldo pendiente en este grupo.",
                              ),
                            ),
                          );
                        return;
                      }
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => PayDebtPage(
                            sender: meBloc.state.me!,
                            receiver: selectedUser,
                            group: widget.group,
                          ),
                        ),
                      )
                          .then((value) {
                        BlocProvider.of<UploadImageBloc>(context)
                            .add(ResetUploadImageBloc());
                      });
                    }
                  },
                );
              },
              icon: const Icon(Icons.payments_outlined),
              message: "Añadir un pago",
            ),
            ActionButton(
              onPressed: () {
                spendingsBloc.add(SpendingsSetInitialSpendingsEvent());
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => const AddSpendingPage(),
                  ),
                )
                    .then((value) {
                  BlocProvider.of<UploadImageBloc>(context)
                      .add(ResetUploadImageBloc());
                });
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
      if (state.selectedGroup != null) {
        BlocProvider.of<SpendingsBloc>(context).add(
          SpendingUpdateEvent(
            newState: NullableSpendingsUseState(
              selectedGroup: state.selectedGroup,
            ),
          ),
        );
      }
      if (state.groupUsers.isNotEmpty) {
        BlocProvider.of<SpendingsBloc>(context).add(
          SpendingUpdateEvent(
            newState: NullableSpendingsUseState(
              membersInGroup: state.groupUsers,
            ),
          ),
        );
      }
    });
  }

  double _getGroupTotalSpendings(List<SpendingModel> groupSpendings) {
    double total = 0;
    for (var spending in groupSpendings) {
      total += spending.amount;
    }
    return total;
  }

  List<Widget> _createActivityList(
    List<SpendingModel> spendings,
    List<PaymentModel> payments,
    List<UserModel> users,
    BuildContext context,
  ) {
    List<Widget> activityWidgetsList = [];
    final List<dynamic> spendingsAndPayments = [...spendings, ...payments];
    spendingsAndPayments.sort((itemA, itemB) {
      late final Timestamp timestampA;
      late final Timestamp timestampB;
      if (itemA is SpendingModel) {
        timestampA = itemA.createdAt;
      } else if (itemA is PaymentModel) {
        timestampA = itemA.createdAt;
      } else {
        throw "Only spendings and payments should be used";
      }

      if (itemB is SpendingModel) {
        timestampB = itemB.createdAt;
      } else if (itemB is PaymentModel) {
        timestampB = itemB.createdAt;
      } else {
        throw "Only spendings and payments should be used";
      }
      return timestampB.compareTo(timestampA);
    });

    final Map<DocumentReference<Map<String, dynamic>>, UserModel>
        userRefToUserModelMap = Map.fromEntries(users
            .map((user) =>
                MapEntry(GroupsRepository.usersCollection.doc(user.uid), user))
            .toList());
    DateTime currMonth = DateTime.now();
    for (int i = 0; i < spendingsAndPayments.length; i++) {
      String title = "";
      String subtitle = "";
      VoidCallback onTap = () {};
      dynamic activity = spendingsAndPayments[i];
      if (activity is SpendingModel) {
        title = activity.description;
        if (activity.createdAt.toDate().month != currMonth.month || i == 0) {
          currMonth = activity.createdAt.toDate();
          activityWidgetsList.add(
            _getActivityDateDivider(
                dateFormat.format(currMonth), currMonth.year),
          );
        }
        final user = userRefToUserModelMap[activity.paidBy]!;
        subtitle =
            "${user.displayName ?? user.fullName ?? '<No username>'} realizó un pago de \$${activity.amount.toStringAsFixed(2)}";
        onTap = () {
          BlocProvider.of<SpendingDetailBloc>(context)
              .add(GetSpendingDetailEvent(spending: activity));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpendingDetailPage(),
            ),
          );
        };
      } else if (activity is PaymentModel) {
        title = activity.description;
        if (activity.createdAt.toDate().month != currMonth.month || i == 0) {
          currMonth = activity.createdAt.toDate();
          activityWidgetsList.add(
            _getActivityDateDivider(
                dateFormat.format(currMonth), currMonth.year),
          );
        }
        final payer = userRefToUserModelMap[activity.payer]!;
        final receiver = userRefToUserModelMap[activity.receiver]!;
        subtitle =
            "${payer.displayName ?? payer.fullName ?? '<No username>'} pagó a ${receiver.displayName ?? receiver.fullName ?? '<No username>'} \$${activity.amount.toStringAsFixed(2)}";
        onTap = () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaymentDetailPage(
                payer: payer,
                receiver: receiver,
                payment: activity,
              ),
            ),
          );
        };
      }
      activityWidgetsList.add(_getActivityTile(
          title, subtitle, dateFormat.format(currMonth), currMonth.day, onTap));
    }
    return activityWidgetsList;
  }

  Widget _getActivityDateDivider(String month, int year) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Text(
        '${month[0].toUpperCase() + month.substring(1)} del $year',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        textAlign: TextAlign.center,
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

  void _listenForRealtimeUpdates() {
    groupsBloc.add(
      const UpdateGroupsStateEvent(
        newState: NullableGroupsUseState(isLoadingActivity: true),
      ),
    );
    _groupActivityStreamSubscription = GroupsRepository.getActivitySubscription(
      widget.group,
      (groupActivity) {
        groupsBloc.add(
          UpdateGroupsStateEvent(
            newState: NullableGroupsUseState(
              isLoadingActivity: false,
              payments: groupActivity.payments,
              spendings: groupActivity.spendings,
            ),
          ),
        );
      },
    );
  }
}

class UserAndHowMuchIOweThem {
  final UserModel user;
  final double howMuchDoIOweThem;

  UserAndHowMuchIOweThem({
    required this.user,
    required this.howMuchDoIOweThem,
  });
}

class SelectPayeeSearchDelegate
    extends SearchDelegate<UserAndHowMuchIOweThem?> {
  SelectPayeeSearchDelegate() : super(searchFieldLabel: "Registrar pago a...");

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
    List<UserAndHowMuchIOweThem> queryResult = getResults(context);
    return ListView.builder(
      itemCount: queryResult.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const SizedBox(height: 16);
        }
        UserAndHowMuchIOweThem user = queryResult[index - 1];
        return getUserTile(context, user);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<UserAndHowMuchIOweThem> queryResult = getResults(context);
    queryResult = queryResult.sublist(
      0,
      queryResult.length > 10 ? 10 : queryResult.length,
    );
    return ListView.builder(
      itemCount: queryResult.length,
      itemBuilder: (BuildContext context, int index) {
        UserAndHowMuchIOweThem user = queryResult[index];
        return getUserTile(context, user);
      },
    );
  }

  List<UserAndHowMuchIOweThem> getResults(BuildContext context) {
    UserModel me = BlocProvider.of<MeBloc>(context).state.me!;
    List<UserAndHowMuchIOweThem> membersInGroup =
        BlocProvider.of<GroupsBloc>(context)
            .state
            .groupUsers
            .where((user) => user != me)
            .map((user) => UserAndHowMuchIOweThem(
                user: user,
                howMuchDoIOweThem: _getHowMuchIOweToFriend(user, context)))
            .where((userAndHowMuchIOweThem) =>
                userAndHowMuchIOweThem.howMuchDoIOweThem > 0)
            .toList();

    if (membersInGroup.isEmpty) {
      close(context, UserAndHowMuchIOweThem(user: me, howMuchDoIOweThem: 0));
      return [];
    }

    String queryLC = query.toLowerCase();
    return queryLC == ""
        ? membersInGroup
        : membersInGroup
            .where(
              (element) =>
                  ((element.user.displayName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0) ||
                  ((element.user.firstName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0) ||
                  ((element.user.lastName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0),
            )
            .toList();
  }

  Widget getUserTile(BuildContext context, UserAndHowMuchIOweThem userAndDebt) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: InkWell(
          onTap: () {
            close(context, userAndDebt);
          },
          child: ListTile(
            title: Text(userAndDebt.user.displayName ??
                userAndDebt.user.fullName ??
                '<Sin Nombre>'),
            subtitle: Text(
                "Le debes un total de \$${userAndDebt.howMuchDoIOweThem.toStringAsFixed(2)}"),
            leading: CircleAvatar(
              backgroundImage: userAndDebt.user.pictureUrl == null ||
                      userAndDebt.user.pictureUrl == ""
                  ? const NetworkImage(
                      "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                    )
                  : NetworkImage(userAndDebt.user.pictureUrl!),
            ),
          ),
        ),
      ),
    );
  }

  double _getHowMuchIOweToFriend(
    UserModel friend,
    BuildContext context,
  ) {
    UserModel? me = BlocProvider.of<MeBloc>(context).state.me!;
    if (friend == me) {
      return 0;
    }
    UserActivityUseState state =
        BlocProvider.of<UserActivityBloc>(context).state;
    GroupModel? currentGroup =
        BlocProvider.of<GroupsBloc>(context).state.selectedGroup;
    double howMuchDoIMyFriend = 0;

    for (final GroupSpendingModel spendingDetail in state.spendingsDetails) {
      if (spendingDetail.user.id == me.uid) {
        try {
          SpendingModel spending = state.spendingsWhereIDidNotPay.firstWhere(
            (spendingWhereIDidNotPay) =>
                spendingWhereIDidNotPay.spendingId ==
                    spendingDetail.spending.id &&
                spendingWhereIDidNotPay.paidBy.id == friend.uid &&
                spendingWhereIDidNotPay.group.id == currentGroup?.groupId,
          );
          spending.paidBy;
          howMuchDoIMyFriend += spendingDetail.amountToPay;
        } catch (e) {
          howMuchDoIMyFriend;
        }
      }
    }

    for (final PaymentModel paymentMadeByMe in state.paymentsMadeByMe) {
      if (paymentMadeByMe.receiver.id == friend.uid &&
          paymentMadeByMe.group.id == currentGroup?.groupId) {
        howMuchDoIMyFriend -= paymentMadeByMe.amount;
      }
    }
    return howMuchDoIMyFriend;
  }
}
