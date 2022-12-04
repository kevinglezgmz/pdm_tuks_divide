import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_repository.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/payment_detail_page/payment_detail_page.dart';
import 'package:tuks_divide/pages/spending_detail_page/spending_detail_page.dart';

class UserProfileActivityPage extends StatefulWidget {
  const UserProfileActivityPage({super.key});

  @override
  State<UserProfileActivityPage> createState() =>
      _UserProfileActivityPageState();
}

class _UserProfileActivityPageState extends State<UserProfileActivityPage> {
  late final StreamSubscription<NullableUserActivityUseState>
      _userActivityStreamSubscription;
  late final AuthBloc authBloc;
  late final UserActivityBloc userActivityBloc;
  final dateFormat = DateFormat.MMMM('es');

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    userActivityBloc = BlocProvider.of<UserActivityBloc>(context);
    _listenForRealtimeUpdates();
    super.initState();
  }

  @override
  void dispose() {
    _userActivityStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserActivityBloc, UserActivityUseState>(
      builder: (context, state) {
        if (state.isLoadingPaymentsByMe ||
            state.isLoadingPaymentsToMe ||
            state.isLoadingSpendings) {
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
                    const SizedBox(height: 30),
                    Text(
                      authBloc.me!.displayName ??
                          authBloc.me!.fullName ??
                          "<No name>",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cargando adeudos...',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Cargando saldos pendientes...',
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
                              authBloc.me!.pictureUrl == ""
                          ? const NetworkImage(
                              "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                          : NetworkImage(authBloc.me!.pictureUrl!)),
                )),
            Positioned(
              top: 128 + 48,
              right: 0,
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    authBloc.me!.displayName ??
                        authBloc.me!.fullName ??
                        "<No name>",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      double amountIOwe = _howMuchDoIOwe(state, authBloc.me!);
                      if (amountIOwe <= 0.00) {
                        return const Text(
                          "No tienes ninguna deuda!",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        );
                      }
                      return Text(
                        "Debes un total de: \$$amountIOwe",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      double amountTheyOweMe =
                          _howMuchDoTheyOweMe(state, authBloc.me!);
                      if (amountTheyOweMe <= 0.00) {
                        return const Text(
                          "Nadie tiene deudas contigo!",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        );
                      }
                      return Text(
                        'Te deben un total de: \$$amountTheyOweMe',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
                top: 294,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _createActivityList(
                      state,
                      authBloc.me!,
                      context,
                    ),
                  ),
                ))
          ],
        );
      },
    );
  }

  double _howMuchDoIOwe(UserActivityUseState state, UserModel me) {
    double totalIOwe = 0;
    for (final SpendingModel spending in state.spendingsWhereIDidNotPay) {
      try {
        final spendingDetail = state.spendingsDetails.firstWhere(
          (spendingDetail) =>
              spendingDetail.user.id == me.uid &&
              spendingDetail.spending.id == spending.spendingId,
        );
        totalIOwe += spendingDetail.amountToPay;
      } catch (e) {
        totalIOwe;
      }
    }
    for (final PaymentModel payment in state.paymentsMadeByMe) {
      totalIOwe -= payment.amount;
    }
    return double.parse(totalIOwe.toStringAsFixed(2));
  }

  double _howMuchDoTheyOweMe(UserActivityUseState state, UserModel me) {
    double totalTheyOweMe = 0;
    for (final SpendingModel spending in state.spendingsWhereIPaid) {
      for (final GroupSpendingModel spendingDetail in state.spendingsDetails) {
        if (spendingDetail.spending.id == spending.spendingId &&
            spendingDetail.user.id != me.uid) {
          totalTheyOweMe += spendingDetail.amountToPay;
        }
      }
    }
    for (final PaymentModel payment in state.paymentsMadeToMe) {
      totalTheyOweMe -= payment.amount;
    }
    return double.parse(totalTheyOweMe.toStringAsFixed(2));
  }

  List<Widget> _createActivityList(
    UserActivityUseState state,
    UserModel me,
    BuildContext context,
  ) {
    List<Widget> activityList = [];
    Set<SpendingModel> spendingsIPaid = Set.from(state.spendingsWhereIPaid);
    Set<SpendingModel> spendingsIDidNotPay =
        Set.from(state.spendingsWhereIDidNotPay);
    Set<PaymentModel> paymentsMadeByMe = Set.from(state.paymentsMadeByMe);
    Set<PaymentModel> paymentsMadeToMe = Set.from(state.paymentsMadeToMe);
    List<dynamic> allUserActivity = [
      ...state.paymentsMadeByMe,
      ...state.paymentsMadeToMe,
      ...state.spendingsWhereIPaid,
      ...state.spendingsWhereIDidNotPay,
    ];
    Map<String, UserModel> userIdToUserMap = state.userIdToUserMap;
    allUserActivity.sort((activityA, activityB) {
      late final Timestamp timestampA;
      late final Timestamp timestampB;
      if (activityA is SpendingModel) {
        timestampA = activityA.createdAt;
      } else if (activityA is PaymentModel) {
        timestampA = activityA.createdAt;
      } else {
        throw "Only spendings and payments are allowed";
      }
      if (activityB is SpendingModel) {
        timestampB = activityB.createdAt;
      } else if (activityB is PaymentModel) {
        timestampB = activityB.createdAt;
      } else {
        throw "Only spendings and payments are allowed";
      }
      return timestampB.compareTo(timestampA);
    });

    if (allUserActivity.isEmpty) {
      activityList.add(const Text(
        "No hay actividad para mostrar",
        textAlign: TextAlign.center,
      ));
      return activityList;
    }

    DateTime currMonth = DateTime.now();

    for (int i = 0; i < allUserActivity.length; i++) {
      final dynamic activity = allUserActivity[i];
      UserModel? user;
      String title = "";
      String subtitle = "";
      VoidCallback onTap = () {};

      if (activity is PaymentModel) {
        if (paymentsMadeByMe.contains(activity)) {
          title = activity.description;
          user = userIdToUserMap[activity.receiver.id];
          subtitle =
              "Realizaste un pago de \$${activity.amount} a ${user?.displayName ?? user?.fullName ?? "<Sin nombre>"}";
        } else if (paymentsMadeToMe.contains(activity)) {
          title = activity.description;
          user = userIdToUserMap[activity.payer.id];
          subtitle =
              "${user?.displayName ?? user?.fullName ?? "<Sin nombre>"} te hizo un pago de \$${activity.amount}";
        }
        onTap = () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PaymentDetailPage(
                payment: activity,
                payer: userIdToUserMap[activity.payer.id]!,
                receiver: userIdToUserMap[activity.receiver.id]!,
              ),
            ),
          );
        };
        if (activity.createdAt.toDate().month != currMonth.month || i == 0) {
          currMonth = activity.createdAt.toDate();
          activityList.add(_getActivityDateDivider(
              dateFormat.format(currMonth), currMonth.year));
        }
      } else if (activity is SpendingModel) {
        if (spendingsIDidNotPay.contains(activity)) {
          user = userIdToUserMap[activity.paidBy.id];
          GroupSpendingModel? spendingDetail;
          try {
            spendingDetail = state.spendingsDetails.firstWhere((element) =>
                element.spending.id == activity.spendingId &&
                element.user.id == me.uid);
          } catch (e) {
            spendingDetail = null;
          }
          title = "${activity.description} (deuda) ";
          subtitle =
              "${user?.displayName ?? user?.fullName ?? "<Sin nombre>"} te prestó un total de \$${spendingDetail?.amountToPay.toStringAsFixed(2) ?? "0.00"}";
        } else if (spendingsIPaid.contains(activity)) {
          title = activity.description;
          subtitle =
              "Pagaste una cuenta de \$${activity.amount.toStringAsFixed(2)}";
        }
        onTap = () {
          BlocProvider.of<SpendingDetailBloc>(context)
              .add(GetSpendingDetailEvent(spending: activity));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpendingDetailPage(),
            ),
          );
        };
        if (activity.createdAt.toDate().month != currMonth.month || i == 0) {
          currMonth = activity.createdAt.toDate();
          activityList.add(_getActivityDateDivider(
              dateFormat.format(currMonth), currMonth.year));
          activityList.add(
            const SizedBox(height: 8),
          );
        }
      }

      activityList.add(_getActivityTile(
          title, subtitle, dateFormat.format(currMonth), currMonth.day, onTap));
    }

    return activityList;
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
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        minLeadingWidth: 28,
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.attach_money),
      ),
    ));
  }

  void _listenForRealtimeUpdates() {
    userActivityBloc.add(
      const UserActivityUpdateStateEvent(
        newState: NullableUserActivityUseState(
          isLoadingPaymentsByMe: true,
          isLoadingPaymentsToMe: true,
          isLoadingSpendings: true,
        ),
      ),
    );
    _userActivityStreamSubscription =
        UserActivityRepository.getUserActivitySubscription(
      authBloc.me!,
      (groupActivityState) {
        userActivityBloc.add(
          UserActivityUpdateStateEvent(
            newState: groupActivityState,
          ),
        );
      },
    );
  }
}
