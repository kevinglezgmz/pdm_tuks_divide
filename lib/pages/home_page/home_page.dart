import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/spendings_bloc/bloc/spendings_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/pages/edit_user_profile_page/edit_user_profile_page.dart';
import 'package:tuks_divide/pages/edit_user_profile_page/notifications_page.dart';
import 'package:tuks_divide/pages/friends_page/friends_page.dart';
import 'package:tuks_divide/pages/group_expenses_page/group_expenses_page.dart';
import 'package:tuks_divide/pages/user_profile_activity_page/user_profile_activity_page.dart';
import 'package:tuks_divide/pages/groups_page/groups_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String windowTitle = "Tuks Divide";
  int index = 0;
  List<Widget> actions = [];

  @override
  void initState() {
    actions = [
      IconButton(
        onPressed: () {
          _searchGroupByName(context);
        },
        icon: const Icon(Icons.search),
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(windowTitle),
          actions: actions,
        ),
        body: IndexedStack(
          index: index,
          children: const [
            GroupsPage(),
            FriendsPage(),
            UserProfileActivityPage(),
            EditUserProfilePage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (int newIndex) {
            BlocProvider.of<UploadImageBloc>(context)
                .add(ResetUploadImageBloc());
            setState(() {
              actions = [];
              if (newIndex == 1) {
                windowTitle = "Mis amigos";
              } else if (newIndex == 2) {
                windowTitle =
                    "Actividad de ${context.read<MeBloc>().state.me!.displayName ?? context.read<MeBloc>().state.me!.fullName ?? "<No name>"}";
              } else if (newIndex == 3) {
                windowTitle = "Editar perfil";
                actions = [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications),
                  )
                ];
              } else {
                windowTitle = "Tuks Divide";
                actions = [
                  IconButton(
                    onPressed: () {
                      _searchGroupByName(context);
                    },
                    icon: const Icon(Icons.search),
                  )
                ];
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
      ),
    );
  }

  void _searchGroupByName(BuildContext context) {
    showSearch(context: context, delegate: SelectGroupSearchDelegare()).then(
      (group) {
        if (group != null) {
          BlocProvider.of<GroupsBloc>(context)
              .add(LoadGroupUsersEvent(group: group));
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => GroupExpensesPage(
                    group: group,
                  ),
                ),
              )
              .then(
                (value) => BlocProvider.of<SpendingsBloc>(context).add(
                  SpendingsResetBlocEvent(),
                ),
              )
              .then((value) => BlocProvider.of<UploadImageBloc>(context)
                  .add(ResetUploadImageBloc()));
        }
      },
    );
  }
}

class SelectGroupSearchDelegare extends SearchDelegate<GroupModel?> {
  SelectGroupSearchDelegare()
      : super(searchFieldLabel: "Buscar grupo por nombre...");

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
    List<GroupModel> queryResult = getResults(context);
    return ListView.builder(
      itemCount: queryResult.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const SizedBox(height: 16);
        }
        GroupModel group = queryResult[index - 1];
        return _getGroupTile(
          group,
          context,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<GroupModel> queryResult = getResults(context);
    queryResult = queryResult.sublist(
      0,
      queryResult.length > 10 ? 10 : queryResult.length,
    );
    return ListView.builder(
      itemCount: queryResult.length,
      itemBuilder: (BuildContext context, int index) {
        GroupModel group = queryResult[index];
        return _getGroupTile(
          group,
          context,
        );
      },
    );
  }

  List<GroupModel> getResults(BuildContext context) {
    List<GroupModel> userGroups =
        BlocProvider.of<GroupsBloc>(context).state.userGroups;

    if (userGroups.isEmpty) {
      close(context, null);
      return [];
    }

    String queryLC = query.toLowerCase();
    return queryLC == ""
        ? userGroups
        : userGroups
            .where(
              (element) => element.groupName
                  .toLowerCase()
                  .contains(queryLC.toLowerCase()),
            )
            .toList();
  }

  Widget _getGroupTile(GroupModel group, BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          close(context, group);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: ListTile(
            title: Text(group.groupName),
            subtitle: Text(
              "${group.description}\n",
              maxLines: 2,
            ),
            leading: CircleAvatar(
                backgroundImage: group.groupPicUrl == ""
                    ? const NetworkImage(
                        "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                    : NetworkImage(group.groupPicUrl)),
          ),
        ),
      ),
    );
  }
}
