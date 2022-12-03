import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/create_group_bloc/bloc/create_group_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/pages/create_group_page/create_group_page.dart';
import 'package:tuks_divide/pages/groups_page/group_list.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

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
        BlocConsumer<GroupsBloc, GroupsUseState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.isLoadingGroups) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.userGroups.isNotEmpty) {
              return GroupList(
                groupData: state.userGroups,
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
          heroTag: 'Add Group',
          onPressed: () {
            BlocProvider.of<CreateGroupBloc>(context)
                .add(InitGroupCreateEvent());
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateGroupPage()),
            );
          },
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
      )
    ]);
  }
}
