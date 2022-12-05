import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/notifications_bloc/bloc/notifications_bloc.dart';
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

enum FilterType {
  all,
  paymentsMadeToMe,
  paymentsMadeByMe,
  spendingsWhereIPaid,
  spendingsWhereIDidNotPay,
}

class _UserProfileActivityPageState extends State<UserProfileActivityPage> {
  late final StreamSubscription<NullableUserActivityUseState>
      _userActivityStreamSubscription;
  late final AuthBloc authBloc;
  late final UserActivityBloc userActivityBloc;
  final dateFormat = DateFormat.MMMM('es');
  FilterType filterType = FilterType.all;

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
                    BlocBuilder<MeBloc, MeUseState>(
                      builder: (context, state) {
                        return Text(
                          state.me!.displayName ??
                              state.me!.fullName ??
                              "<No name>",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
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
              height: 96,
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
                top: 48,
                right: 0,
                left: 0,
                child: Center(
                  child: BlocBuilder<MeBloc, MeUseState>(
                    builder: (context, state) {
                      return CircleAvatar(
                          radius: 55,
                          backgroundImage: state.me!.pictureUrl == null ||
                                  state.me!.pictureUrl == ""
                              ? const NetworkImage(
                                  "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                              : NetworkImage(state.me!.pictureUrl!));
                    },
                  ),
                )),
            BlocBuilder<MeBloc, MeUseState>(
              builder: (context, meState) {
                return Positioned(
                  top: 142,
                  right: 0,
                  left: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        meState.me!.displayName ??
                            meState.me!.fullName ??
                            "<No name>",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          double amountIOwe = _howMuchDoIOwe(
                            state,
                            meState.me!,
                          );
                          amountIOwe =
                              double.parse(amountIOwe.toStringAsFixed(2));
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
                              _howMuchDoTheyOweMe(state, meState.me!);
                          amountTheyOweMe =
                              double.parse(amountTheyOweMe.toStringAsFixed(2));
                          if (amountTheyOweMe <= 0.00) {
                            return const Text(
                              "Nadie tiene deudas contigo!",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            );
                          }
                          return Text(
                            'Te deben un total de: ${amountTheyOweMe.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              top: 265,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          filterType == FilterType.all
                              ? const Color.fromARGB(255, 42, 42, 42)
                              : const Color.fromARGB(255, 78, 77, 77),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          filterType = FilterType.all;
                        });
                      },
                      child: const Text(
                        'Todo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          filterType == FilterType.paymentsMadeByMe
                              ? const Color.fromARGB(255, 42, 42, 42)
                              : const Color.fromARGB(255, 78, 77, 77),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          filterType = FilterType.paymentsMadeByMe;
                        });
                      },
                      child: const Text(
                        'Pagos enviados por mi',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          filterType == FilterType.paymentsMadeToMe
                              ? const Color.fromARGB(255, 42, 42, 42)
                              : const Color.fromARGB(255, 78, 77, 77),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          filterType = FilterType.paymentsMadeToMe;
                        });
                      },
                      child: const Text(
                        'Pagos enviados a mí',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          filterType == FilterType.spendingsWhereIPaid
                              ? const Color.fromARGB(255, 42, 42, 42)
                              : const Color.fromARGB(255, 78, 77, 77),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          filterType = FilterType.spendingsWhereIPaid;
                        });
                      },
                      child: const Text(
                        'Gastos realizados por mí',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          filterType == FilterType.spendingsWhereIDidNotPay
                              ? const Color.fromARGB(255, 42, 42, 42)
                              : const Color.fromARGB(255, 78, 77, 77),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          filterType = FilterType.spendingsWhereIDidNotPay;
                        });
                      },
                      child: const Text(
                        'Gastos realizados por otros',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 315,
                left: 0,
                right: 0,
                bottom: 0,
                child: BlocBuilder<MeBloc, MeUseState>(
                  builder: (context, meState) {
                    final List<Widget> activityList = _createActivityList(
                        state, meState.me!, context, filterType);
                    if (activityList.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: activityList,
                        ),
                      );
                    } else {
                      return SizedBox.expand(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text("No hay actividad para mostrar."),
                              SizedBox(height: 16),
                              Text("Empiezan creando un grupo!"),
                              SizedBox(height: 48),
                            ],
                          ),
                        ),
                      );
                    }
                  },
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

  List<Widget> _createActivityList(UserActivityUseState state, UserModel me,
      BuildContext context, FilterType filterType) {
    List<Widget> activityList = [];
    Set<SpendingModel> spendingsIPaid = Set.from(state.spendingsWhereIPaid);
    Set<SpendingModel> spendingsIDidNotPay =
        Set.from(state.spendingsWhereIDidNotPay);
    Set<PaymentModel> paymentsMadeByMe = Set.from(state.paymentsMadeByMe);
    Set<PaymentModel> paymentsMadeToMe = Set.from(state.paymentsMadeToMe);
    List<dynamic> allUserActivity;
    if (filterType == FilterType.paymentsMadeByMe) {
      allUserActivity = [
        ...state.paymentsMadeByMe,
      ];
    } else if (filterType == FilterType.paymentsMadeToMe) {
      allUserActivity = [
        ...state.paymentsMadeToMe,
      ];
    } else if (filterType == FilterType.spendingsWhereIPaid) {
      allUserActivity = [
        ...state.spendingsWhereIPaid,
      ];
    } else if (filterType == FilterType.spendingsWhereIDidNotPay) {
      allUserActivity = [
        ...state.spendingsWhereIDidNotPay,
      ];
    } else {
      allUserActivity = [
        ...state.paymentsMadeByMe,
        ...state.paymentsMadeToMe,
        ...state.spendingsWhereIPaid,
        ...state.spendingsWhereIDidNotPay,
      ];
    }
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
      return [];
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
              "Realizaste un pago de \$${activity.amount.toStringAsFixed(2)} a ${user?.displayName ?? user?.fullName ?? "<Sin nombre>"}";
        } else if (paymentsMadeToMe.contains(activity)) {
          title = activity.description;
          user = userIdToUserMap[activity.payer.id];
          subtitle =
              "${user?.displayName ?? user?.fullName ?? "<Sin nombre>"} te hizo un pago de \$${activity.amount.toStringAsFixed(2)}";
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
        subtitle: Text(
          "$subtitle\n",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
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
    PaymentModel? lastPaymentNotiFor;
    SpendingModel? lastSpendingNotiFor;
    _userActivityStreamSubscription =
        UserActivityRepository.getUserActivitySubscription(
      context.read<MeBloc>().state.me!,
      (groupActivityState) {
        if (groupActivityState.newPaymentMadeToMe != null &&
            lastPaymentNotiFor != groupActivityState.newPaymentMadeToMe &&
            BlocProvider.of<NotificationsBloc>(context)
                .state
                .paymentNotificationsEnabled) {
          lastPaymentNotiFor = groupActivityState.newPaymentMadeToMe;
          UserModel? payer = groupActivityState.userIdToUserMap?[
              groupActivityState.newPaymentMadeToMe?.payer.id];
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 3,
              channelKey: 'new_payment_channel',
              title:
                  '${payer?.displayName ?? payer?.fullName} te ha hecho un pago de \$${groupActivityState.newPaymentMadeToMe?.amount.toStringAsFixed(2)}!',
              body:
                  'Dirígete a la pantalla de actividad para ver los detalles del pago con concepto \'${groupActivityState.newPaymentMadeToMe?.description}\'!',
              actionType: ActionType.DismissAction,
              notificationLayout: NotificationLayout.BigText,
            ),
          );
        }
        if (groupActivityState.newSpendingIParticipatedIn != null &&
            groupActivityState.newSpendingIParticipatedIn !=
                lastSpendingNotiFor &&
            BlocProvider.of<NotificationsBloc>(context)
                .state
                .spendingNotificationsEnabled) {
          UserModel? addedBy = groupActivityState.userIdToUserMap?[
              groupActivityState.newSpendingIParticipatedIn?.addedBy.id];
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 4,
              channelKey: 'new_spending_channel',
              title:
                  '${addedBy?.displayName ?? addedBy?.fullName} te ha incluido en un gasto de \$${groupActivityState.newSpendingIParticipatedIn?.amount.toStringAsFixed(2)}!',
              body:
                  'Dirígete a la pantalla de actividad para ver los detalles del gasto \'${groupActivityState.newSpendingIParticipatedIn?.description}\'!',
              actionType: ActionType.DismissAction,
              notificationLayout: NotificationLayout.BigText,
            ),
          );
          lastSpendingNotiFor = groupActivityState.newSpendingIParticipatedIn;
        }
        groupActivityState
                .userIdToUserMap?[context.read<MeBloc>().state.me!.uid] =
            context.read<MeBloc>().state.me!;
        userActivityBloc.add(
          UserActivityUpdateStateEvent(
            newState: groupActivityState,
          ),
        );
      },
    );
  }
}
