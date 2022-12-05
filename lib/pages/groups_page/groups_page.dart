import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/create_group_bloc/bloc/create_group_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/notifications_bloc/bloc/notifications_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/pages/create_group_page/create_group_page.dart';
import 'package:tuks_divide/pages/groups_page/group_list.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _myGroupsSubscription;
  late final GroupsBloc groupsBloc;

  @override
  void initState() {
    groupsBloc = BlocProvider.of<GroupsBloc>(context);
    _listenForRealtimeUpdates();
    super.initState();
  }

  @override
  void dispose() async {
    _myGroupsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 10.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Tus grupos",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              BlocConsumer<GroupsBloc, GroupsUseState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state.isLoadingGroups) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state.userGroups.isNotEmpty) {
                    return GroupList(
                      groupData: state.userGroups,
                    );
                  } else {
                    return Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Expanded(flex: 40, child: SizedBox.shrink()),
                          Text(
                            "No tienes ningún grupo!",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Crea uno!",
                            style: TextStyle(fontSize: 16),
                          ),
                          Expanded(flex: 60, child: SizedBox.shrink()),
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
        Positioned(
          right: 15.0,
          bottom: 15.0,
          child: FloatingActionButton(
            heroTag: 'Add Group',
            onPressed: () {
              BlocProvider.of<CreateGroupBloc>(context)
                  .add(InitGroupCreateEvent());
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                        builder: (context) => const CreateGroupPage()),
                  )
                  .then((value) => BlocProvider.of<UploadImageBloc>(context)
                      .add(ResetUploadImageBloc()));
            },
            child: const FaIcon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  void _listenForRealtimeUpdates() {
    groupsBloc.add(
      const UpdateGroupsStateEvent(
        newState: NullableGroupsUseState(isLoadingGroups: true),
      ),
    );
    Timestamp currTime = Timestamp.now();
    _myGroupsSubscription = GroupsRepository.getUserGroupsSubscription(
      (groups) {
        if (groups.isNotEmpty &&
            groups.last.createdAt.compareTo(currTime) > 0 &&
            groups.last.owner.id !=
                BlocProvider.of<MeBloc>(context).state.me!.uid &&
            BlocProvider.of<NotificationsBloc>(context)
                .state
                .groupNotificationsEnabled) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 1,
              channelKey: 'new_group_channel',
              title: 'Has sido agregado a un nuevo grupo!',
              body:
                  'Dirígete a la pantalla de grupos para ver el nuevo grupo ${groups.last.groupName}',
              actionType: ActionType.DismissAction,
              notificationLayout: NotificationLayout.BigText,
            ),
          );
          currTime = groups.last.createdAt;
        }
        groupsBloc.add(
          UpdateGroupsStateEvent(
            newState: NullableGroupsUseState(
              userGroups: groups,
              isLoadingGroups: false,
            ),
          ),
        );
      },
    );
  }
}
