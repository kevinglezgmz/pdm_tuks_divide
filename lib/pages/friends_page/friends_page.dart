import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/components/text_input_field.dart';
import 'package:tuks_divide/models/user_model.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

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
        BlocConsumer<FriendsBloc, FriendsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is FriendsLoadingState ||
                state is FriendsAddingFriendstate) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FriendsLoadedState) {
              return _getFriendsList(
                state.friends,
              );
            }
            return const Text('Error');
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
          child: const FaIcon(FontAwesomeIcons.plus),
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
          BlocListener<FriendsBloc, FriendsState>(
            listener: (context, state) {
              if (state is FriendsAddedFriendstate) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        'Se añadió ${emailController.text} a tu lista de amigos',
                      ),
                    ),
                  );
                Navigator.of(context).pop();
              } else if (state is FriendsAddingErrorState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error añadiendo ${emailController.text} a tu lista de amigos: ${state.errorMessage}',
                      ),
                    ),
                  );
                Navigator.of(context).pop();
              } else if (state is FriendsAddingFriendstate) {}
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
}
