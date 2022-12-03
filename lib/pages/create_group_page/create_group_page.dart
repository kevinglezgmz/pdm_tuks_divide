import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/create_group_bloc/bloc/create_group_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/components/add_picture_widget.dart';
import 'package:tuks_divide/components/avatar_widget.dart';
import 'package:tuks_divide/components/elevated_button_with_icon.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/create_group_page/member_list.dart';

class CreateGroupPage extends StatelessWidget {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController =
      TextEditingController();
  CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool creatingGroup = false;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.xmark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Crear un grupo",
        ),
        actions: [
          TextButton(
            onPressed: () {
              final String pictureUrl =
                  BlocProvider.of<UploadImageBloc>(context).uploadedImageUrl ??
                      '';
              BlocProvider.of<GroupsBloc>(context).add(
                AddNewGroupEvent(
                  description: _groupDescriptionController.text,
                  groupName: _groupNameController.text,
                  pictureUrl: pictureUrl,
                  members: BlocProvider.of<CreateGroupBloc>(context).members,
                ),
              );
            },
            child: const Text(
              "Guardar",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
      body: Column(children: [
        _getGroupPicAndNameSection(context, creatingGroup),
        _getGroupDescriptionSection(),
        _getMembersSectionTitle(),
        _getMembersSection(context),
      ]),
    );
  }

  Container _getMembersSectionTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Miembros del grupo",
        textAlign: TextAlign.left,
      ),
    );
  }

  Padding _getGroupDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 8.0, 19.0, 8.0),
      child: TextField(
        controller: _groupDescriptionController,
        decoration: const InputDecoration(label: Text("Descripción")),
        maxLength: 120,
        maxLines: 3,
      ),
    );
  }

  Padding _getGroupPicAndNameSection(BuildContext context, bool creatingGroup) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<GroupsBloc, GroupsUseState>(
              listener: (context, state) {
                if (state.isCreatingGroup && creatingGroup == false) {
                  creatingGroup = true;
                }
                if (state.isCreatingGroup == false && creatingGroup == true) {
                  Navigator.of(context).pop();
                }
              },
              child: BlocBuilder<UploadImageBloc, UploadImageState>(
                builder: (context, state) {
                  if (state is UploadingSuccessfulState) {
                    return AddPictureWidget(
                      backgroundColor: Colors.grey,
                      radius: 45.0,
                      iconSize: 45,
                      height: 45.0,
                      width: 45.0,
                      avatarUrl: BlocProvider.of<UploadImageBloc>(context)
                          .uploadedImageUrl,
                      onPressed: () {
                        _showAlertDialog(context);
                      },
                    );
                  }
                  return AddPictureWidget(
                    backgroundColor: Colors.grey,
                    radius: 45.0,
                    iconSize: 45,
                    height: 45.0,
                    width: 45.0,
                    onPressed: () {
                      _showAlertDialog(context);
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.49,
            padding: const EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
            child: TextField(
              controller: _groupNameController,
              decoration:
                  const InputDecoration(label: Text("Nombre del grupo")),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cargar imagen"),
        content: const Text("¿Cómo te gustaría cargar la imagen?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<UploadImageBloc>(context)
                  .add(const UploadNewImageEvent("groupImg", "gallery"));
            },
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(14),
              alignment: Alignment.center,
              child: const Text(
                "Seleccionar de la galería",
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              BlocProvider.of<UploadImageBloc>(context)
                  .add(const UploadNewImageEvent("groupImg", "camera"));
            },
            child: Container(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Usar cámara",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddMemberDialog(
      BuildContext context, List<UserModel> availableFriends) {
    return showDialog<UserModel?>(
      context: context,
      builder: (context) => _getFriendsList(availableFriends),
    ).then((member) {
      if (member != null) {
        BlocProvider.of<CreateGroupBloc>(context)
            .add(AddMemberToGroupCreateEvent(userToAdd: member));
      }
    });
  }

  Widget _getFriendsList(List<UserModel> friends) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(friends[index]);
          },
          child: Card(
              child: ListTile(
            leading: friends[index].pictureUrl != null
                ? CircleAvatar(
                    child: Image.network(friends[index].pictureUrl!),
                  )
                : const AvatarWidget(iconSize: 20),
            title: Text(friends[index].displayName ??
                friends[index].fullName ??
                "<No Name>"),
            trailing: const Icon(Icons.delete),
          )),
        );
      },
    );
  }

  Widget _getMembersSection(BuildContext context) {
    return BlocBuilder<FriendsBloc, FriendsState>(
      builder: (friendsContext, friendsState) {
        return BlocBuilder<CreateGroupBloc, CreateGroupState>(
          builder: (createGroupContext, createGroupState) {
            final List<UserModel> friends = [];
            final List<UserModel> selectedMembers = [];
            if (friendsState is FriendsLoadedState) {
              friends.addAll(friendsState.friends);
            }
            if (createGroupState is CreateGroupSelectedMembersState) {
              selectedMembers.addAll(createGroupState.currentGroupMembers);
            }
            final List<UserModel> availableFriends = friends
                .where((friend) => !selectedMembers.contains(friend))
                .toList();
            return Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 20.0),
                    child: ElevatedButtonWithIcon(
                      icon: const FaIcon(
                        FontAwesomeIcons.userPlus,
                      ),
                      onPressed: () {
                        _showAddMemberDialog(
                            createGroupContext, availableFriends);
                      },
                      label: "AÑADIR MIEMBRO",
                      backgroundColor: null,
                    ),
                  ),
                  MemberList(
                    membersData: selectedMembers,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
