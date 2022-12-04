import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_repository.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/notifications_bloc/bloc/notifications_bloc.dart';
import 'package:tuks_divide/components/text_input_field.dart';
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
            return _getFriendsList(
              state.friends,
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
        title: Text(friend.displayName ?? friend.fullName ?? '<Sin Nombre>'),
        // TODO: poner cuantos grupos en comun?
        subtitle: const Text('Algunos grupos en comun'),
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
        newState: NullableFriendsUseState(isLoadingFriends: true),
      ),
    );
    _myFriendsSubscription = FriendsRepository.getUserFriendsSubscription(
      (friendsResult) {
        if (friendsResult.newFriend != null &&
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
}
