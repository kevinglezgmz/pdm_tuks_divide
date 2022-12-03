import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/pages/edit_user_profile_page/edit_user_profile_page.dart';
import 'package:tuks_divide/pages/friends_page/friends_page.dart';
import 'package:tuks_divide/pages/group_profile_activity_page/group_profile_activity_page.dart';
import 'package:tuks_divide/pages/groups_page/groups_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String windowTitle = "Tuks Divide";
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(windowTitle),
      ),
      body: IndexedStack(
        index: index,
        children: [
          const GroupsPage(),
          const FriendsPage(),
          GroupProfileActivityPage(),
          EditUserProfilePage(
            pictureUrl: context.read<AuthBloc>().me!.pictureUrl,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int newIndex) {
          if (newIndex == 2) {
            BlocProvider.of<UserActivityBloc>(context)
                .add(UserActivityLoadEvent());
          }
          setState(() {
            if (newIndex == 1) {
              windowTitle = "Mis amigos";
            } else if (newIndex == 2) {
              windowTitle =
                  "Actividad de ${context.read<AuthBloc>().me!.displayName ?? context.read<AuthBloc>().me!.fullName ?? "<No name>"}";
            } else if (newIndex == 3) {
              windowTitle = "Editar perfil";
            } else {
              windowTitle = "Tuks Divide";
            }
            index = newIndex;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Grupos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Amigos"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartLine), label: "Actividad"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userAstronaut), label: "Cuenta")
        ],
      ),
    );
  }
}
