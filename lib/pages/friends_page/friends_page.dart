import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
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
            "Tus grupos",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        BlocConsumer<FriendsBloc, FriendsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is FriendsLoadingState) {
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
            // TODO: Add friend
          },
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
      )
    ]);
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
        subtitle: Text('Algunos grupos en comun'),
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
