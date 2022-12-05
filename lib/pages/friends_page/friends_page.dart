import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_repository.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/notifications_bloc/bloc/notifications_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/components/text_input_field.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late final StreamSubscription<FriendsStreamResult> _myFriendsSubscription;
  late final FriendsBloc friendsBloc;
  bool isAddingFriend = false;

  @override
  void initState() {
    friendsBloc = BlocProvider.of<FriendsBloc>(context);
    _listenForRealtimeUpdates();
    super.initState();
  }

  @override
  void dispose() async {
    _myFriendsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 10.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Tus amigos",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        BlocConsumer<FriendsBloc, FriendsUseState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.isLoadingFriends) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state.friends.isNotEmpty) {
              return _getFriendsList(
                state.friends,
              );
            }
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Expanded(flex: 40, child: SizedBox.shrink()),
                  Text(
                    "No tienes ningún amigo!",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Añade uno!",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(flex: 60, child: SizedBox.shrink()),
                ],
              ),
            );
          },
        )
      ]),
      Positioned(
        right: 15.0,
        bottom: 15.0,
        child: FloatingActionButton(
          heroTag: 'Add Friend',
          onPressed: () {
            _addFriendDialog(context);
          },
          child: const FaIcon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          ),
        ),
      )
    ]);
  }

  Future<void> _addFriendDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar un amigo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Buscar por correo electrónico:'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextInputField(
                inputController: emailController,
                label: 'Correo',
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          BlocListener<FriendsBloc, FriendsUseState>(
            listener: (context, state) {
              if (state.isAddingFriend && isAddingFriend == false) {
                isAddingFriend = true;
                return;
              }
              if (state.errorMessage != "" && isAddingFriend) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error añadiendo ${emailController.text} a tu lista de amigos: ${state.errorMessage}',
                      ),
                    ),
                  );
                isAddingFriend = false;
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
                return;
              }
              if (state.isAddingFriend == false && isAddingFriend) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        'Se añadió ${emailController.text} a tu lista de amigos',
                      ),
                    ),
                  );
                isAddingFriend = false;
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: ElevatedButton(
              child: const Text('Agregar'),
              onPressed: () {
                BlocProvider.of<FriendsBloc>(context).add(
                  AddNewFriendByMailEvent(
                    email: emailController.text,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _getFriendsList(List<UserModel> friends) {
    return Expanded(
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (BuildContext context, int index) {
          return _getFriendTile(friends[index]);
        },
      ),
    );
  }

  Widget _getFriendTile(UserModel friend) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        title: Text(friend.displayName ?? friend.fullName ?? '<Sin Nombre>'),
        subtitle: BlocBuilder<UserActivityBloc, UserActivityUseState>(
          builder: (context, state) {
            if (state.isLoadingPaymentsByMe ||
                state.isLoadingPaymentsToMe ||
                state.isLoadingSpendings) {
              return const Text('Cargando información...');
            }
            return _getFriendTextBetweenAllGroups(friend, state);
          },
        ),
        leading: CircleAvatar(
            backgroundImage: friend.pictureUrl == null ||
                    friend.pictureUrl == ""
                ? const NetworkImage(
                    "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                : NetworkImage(friend.pictureUrl!)),
      ),
    );
  }

  void _listenForRealtimeUpdates() {
    friendsBloc.add(
      const UpdateFriendsStateEvent(
        newState: NullableFriendsUseState(
          isLoadingFriends: true,
        ),
      ),
    );
    UserModel? lastFriendNotification;
    _myFriendsSubscription = FriendsRepository.getUserFriendsSubscription(
      (friendsResult) {
        if (friendsResult.newFriend != null &&
            friendsResult.newFriend != lastFriendNotification &&
            BlocProvider.of<NotificationsBloc>(context)
                .state
                .friendNotificationsEnabled) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 2,
              channelKey: 'new_friend_channel',
              title:
                  '${friendsResult.newFriend?.displayName ?? friendsResult.newFriend?.fullName ?? "Sin nombre"} te ha añadido como amigo!',
              body: 'Dirígete a la pantalla de amigos para verlo!',
              actionType: ActionType.DismissAction,
              notificationLayout: NotificationLayout.Default,
            ),
          );
          lastFriendNotification = friendsResult.newFriend;
        }
        friendsBloc.add(
          UpdateFriendsStateEvent(
            newState: NullableFriendsUseState(
              friends: friendsResult.friends,
              isLoadingFriends: false,
            ),
          ),
        );
      },
      BlocProvider.of<MeBloc>(context).state.me!,
    );
  }

  Widget _getFriendTextBetweenAllGroups(
    UserModel friend,
    UserActivityUseState state,
  ) {
    double howMuchDoesFriendOweMe = 0;
    double howMuchDoIOweHim = 0;

    for (final GroupSpendingModel spendingDetail in state.spendingsDetails) {
      if (spendingDetail.user.id == friend.uid) {
        try {
          SpendingModel spending = state.spendingsWhereIPaid.firstWhere(
            (spendingWhereIPaid) =>
                spendingWhereIPaid.spendingId == spendingDetail.spending.id,
          );
          spending.paidBy;
          howMuchDoesFriendOweMe += spendingDetail.amountToPay;
        } catch (e) {
          howMuchDoesFriendOweMe;
        }
      } else if (spendingDetail.user.id ==
          BlocProvider.of<MeBloc>(context).state.me!.uid) {
        try {
          SpendingModel spending = state.spendingsWhereIDidNotPay.firstWhere(
            (spendingWhereIDidNotPay) =>
                spendingWhereIDidNotPay.spendingId ==
                    spendingDetail.spending.id &&
                spendingWhereIDidNotPay.paidBy.id == friend.uid,
          );
          spending.paidBy;
          howMuchDoIOweHim += spendingDetail.amountToPay;
        } catch (e) {
          howMuchDoIOweHim;
        }
      }
    }

    for (final PaymentModel paymentMadeToMe in state.paymentsMadeToMe) {
      if (paymentMadeToMe.payer.id == friend.uid) {
        howMuchDoesFriendOweMe -= paymentMadeToMe.amount;
      }
    }

    for (final PaymentModel paymentMadeByMe in state.paymentsMadeByMe) {
      if (paymentMadeByMe.receiver.id == friend.uid) {
        howMuchDoIOweHim -= paymentMadeByMe.amount;
      }
    }
    howMuchDoIOweHim = double.parse(howMuchDoIOweHim.toStringAsFixed(2));
    howMuchDoesFriendOweMe =
        double.parse(howMuchDoesFriendOweMe.toStringAsFixed(2));
    if (howMuchDoIOweHim <= 0 && howMuchDoesFriendOweMe <= 0) {
      return const Text("No tienen deudas pendientes.\nHurra!");
    }
    return Text(
        "Le debes un total de \$${howMuchDoIOweHim.toStringAsFixed(2)}\nTe debe un total de \$${howMuchDoesFriendOweMe.toStringAsFixed(2)}");
  }
}
