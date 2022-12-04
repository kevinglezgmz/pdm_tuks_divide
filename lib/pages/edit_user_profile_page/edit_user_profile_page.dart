import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/update_user_profile_bloc/bloc/update_user_profile_repository.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/components/add_picture_widget.dart';
import 'package:tuks_divide/components/basic_elevated_button.dart';
import 'package:tuks_divide/components/text_input_field.dart';
import 'package:tuks_divide/models/user_model.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      _userStream;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  late final MeBloc meBloc;
  String? pictureUrl;

  @override
  void initState() {
    meBloc = BlocProvider.of<MeBloc>(context);
    _userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(meBloc.state.me!.uid)
        .snapshots()
        .listen((event) {
      if (event.data() == null) {
        return;
      }
      UserModel updatedUser = UserModel.fromMap(event.data()!);
      meBloc.add(UpdateMeEvent(newMe: updatedUser));
      setState(() {
        _displayNameController.text = updatedUser.displayName ?? "";
        _firstNameController.text = updatedUser.firstName ?? "";
        _lastNameController.text = updatedUser.lastName ?? "";
        pictureUrl = updatedUser.pictureUrl ?? "";
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _userStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<UploadImageBloc, UploadImageState>(
              builder: (context, state) {
            if (state is UploadingSuccessfulState) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                child: AddPictureWidget(
                  backgroundColor: Colors.grey,
                  radius: 60,
                  iconSize: 60,
                  avatarUrl: context.read<UploadImageBloc>().uploadedImageUrl,
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
              child: AddPictureWidget(
                backgroundColor: Colors.grey,
                radius: 60,
                iconSize: 60,
                avatarUrl: pictureUrl,
                onPressed: () {
                  _showAlertDialog(context);
                },
              ),
            );
          }),
          _createInputField(
            TextInputField(
              inputController: _firstNameController,
              label: "Nombre",
            ),
          ),
          _createInputField(
            TextInputField(
              inputController: _lastNameController,
              label: "Apellido",
            ),
          ),
          _createInputField(
            TextInputField(
              inputController: _displayNameController,
              label: "Nombre de usuario",
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
            child: BasicElevatedButton(
              label: "ACTUALIZAR CUENTA",
              onPressed: () {
                if (_firstNameController.text.trim() == '' &&
                    _lastNameController.text.trim() == '' &&
                    _displayNameController.text.trim() == '') {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Ingresa datos en por lo menos 1 de los 3 campos.',
                        ),
                      ),
                    );
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                UpdateUserProfileRepository.updateUserProfile(
                  meBloc.state.me!.uid,
                  _firstNameController.text.trim(),
                  _lastNameController.text.trim(),
                  pictureUrl ?? '',
                  _displayNameController.text.trim(),
                ).then((value) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Datos actualizados de manera exitosa',
                        ),
                      ),
                    );
                }).catchError((error) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Error actualizando los datos de usuario',
                        ),
                      ),
                    );
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
            child: BasicElevatedButton(
              label: "CERRAR SESIÓN",
              onPressed: () {
                BlocProvider.of<GroupsBloc>(context)
                    .add(CleanGroupsListOnSignOutEvent());
                BlocProvider.of<FriendsBloc>(context)
                    .add(CleanFriendsListOnSignOutEvent());
                context.read<AuthBloc>().add(AuthSignOutEvent());
              },
            ),
          )
        ],
      ),
    );
  }

  Padding _createInputField(TextInputField input) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0), child: input);
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
}
