import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/create_group_bloc/bloc/create_group_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/components/add_picture_widget.dart';
import 'package:tuks_divide/components/elevated_button_with_icon.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/create_group_page/member_list.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController =
      TextEditingController();
  bool creatingGroup = false;

  late final AuthBloc authBloc;
  late final CreateGroupBloc createGroupBloc;
  late final FriendsBloc friendsBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    createGroupBloc = BlocProvider.of<CreateGroupBloc>(context);
    friendsBloc = BlocProvider.of<FriendsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              if (_groupNameController.text == "" ||
                  _groupDescriptionController.text == "") {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Datos no válidos"),
                    content: const Text(
                      "Recuerda agregar un nombre y una descripción al grupo.",
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Aceptar"),
                      )
                    ],
                  ),
                );
                return;
              }
              if (createGroupBloc.state.membersInGroup.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Agrega miembros al grupo"),
                    content: const Text(
                      "Para crear el grupo es necesario añadir al menos un amigo.",
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Aceptar"),
                      )
                    ],
                  ),
                );
                return;
              }
              final String pictureUrl =
                  BlocProvider.of<UploadImageBloc>(context).uploadedImageUrl ??
                      '';
              BlocProvider.of<GroupsBloc>(context).add(
                AddNewGroupEvent(
                  description: _groupDescriptionController.text,
                  groupName: _groupNameController.text,
                  pictureUrl: pictureUrl,
                  members: createGroupBloc.state.membersInGroup,
                ),
              );
            },
            child: const Text(
              "Guardar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getGroupPicAndNameSection(context),
            _getGroupDescriptionSection(),
            _getMembersSectionTitle(),
            _getMembersSection(context),
          ],
        ),
      ),
    );
  }

  Container _getMembersSectionTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Miembros del grupo:",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16),
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

  Padding _getGroupPicAndNameSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<GroupsBloc, GroupsUseState>(
              listener: (context, state) {
                if (state.isCreatingGroup && creatingGroup == false) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Creando grupo..."),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  );
                  setState(() {
                    creatingGroup = true;
                  });
                }
                if (state.isCreatingGroup == false && creatingGroup == true) {
                  setState(() {
                    creatingGroup = false;
                  });
                  Navigator.of(context).pop();
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

  Future<void> _showAddMemberSearch(
      BuildContext context, List<UserModel> availableFriends) {
    if (availableFriends.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Agrega más amigos"),
          content: const Text("Ya has agregado a todos tus amigos al grupo."),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Aceptar"),
            )
          ],
        ),
      );
      return Future.value();
    }
    return showSearch<List<UserModel>>(
      context: context,
      delegate: SelectGroupMembersSearchDelegate(
        availableFriends: availableFriends,
      ),
    ).then((addedMembers) {
      if (addedMembers == null || addedMembers.isEmpty) {
        return;
      }
      createGroupBloc.add(AddMemberToGroupCreateEvent(
        userToAdd: addedMembers.first,
      ));
    });
  }

  Widget _getMembersSection(BuildContext context) {
    return BlocBuilder<FriendsBloc, FriendsUseState>(
      builder: (friendsContext, friendsState) {
        return BlocBuilder<CreateGroupBloc, CreateGroupUseState>(
          builder: (createGroupContext, createGroupState) {
            final List<UserModel> friends = friendsState.friends;
            final List<UserModel> selectedMembers =
                createGroupState.membersInGroup;
            final List<UserModel> availableFriends = friends
                .where((friend) => !selectedMembers.contains(friend))
                .toList();
            return Container(
              constraints: const BoxConstraints(
                minHeight: 250,
                minWidth: double.infinity,
                maxHeight: 325,
              ),
              child: Column(
                children: [
                  MemberList(
                    membersData: [authBloc.me!, ...selectedMembers],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 20.0),
                    child: ElevatedButtonWithIcon(
                      icon: const FaIcon(
                        FontAwesomeIcons.userPlus,
                      ),
                      onPressed: () {
                        _showAddMemberSearch(
                          createGroupContext,
                          availableFriends,
                        );
                      },
                      label: "AÑADIR MIEMBRO",
                      backgroundColor: null,
                    ),
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

class SelectGroupMembersSearchDelegate extends SearchDelegate<List<UserModel>> {
  final List<UserModel> availableFriends;
  SelectGroupMembersSearchDelegate({required this.availableFriends})
      : super(searchFieldLabel: "Agregar miembros");

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
        close(context, []);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<UserModel> queryResult = getResults(context);
    return ListView.builder(
      itemCount: queryResult.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const SizedBox(height: 16);
        }
        UserModel user = queryResult[index - 1];
        return getUserTile(context, user);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<UserModel> queryResult = getResults(context);
    queryResult = queryResult.sublist(
      0,
      queryResult.length > 10 ? 10 : queryResult.length,
    );
    return ListView.builder(
      itemCount: queryResult.length,
      itemBuilder: (BuildContext context, int index) {
        UserModel user = queryResult[index];
        return getUserTile(context, user);
      },
    );
  }

  List<UserModel> getResults(BuildContext context) {
    String queryLC = query.toLowerCase();
    return queryLC == ""
        ? availableFriends
        : availableFriends
            .where(
              (element) =>
                  ((element.displayName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0) ||
                  ((element.firstName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0) ||
                  ((element.lastName
                              ?.toLowerCase()
                              .indexOf(queryLC.toLowerCase()) ??
                          -1) >=
                      0),
            )
            .toList();
  }

  Widget getUserTile(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: InkWell(
          onTap: () {
            close(context, [user]);
          },
          child: ListTile(
            title: Text(user.displayName ?? user.fullName ?? '<Sin Nombre>'),
            leading: CircleAvatar(
              backgroundImage: user.pictureUrl == null || user.pictureUrl == ""
                  ? const NetworkImage(
                      "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                    )
                  : NetworkImage(user.pictureUrl!),
            ),
          ),
        ),
      ),
    );
  }
}
