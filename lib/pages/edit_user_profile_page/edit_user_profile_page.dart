import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/update_user_profile_bloc/bloc/update_user_profile_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/components/add_picture_widget.dart';
import 'package:tuks_divide/components/basic_elevated_button.dart';
import 'package:tuks_divide/components/text_input_field.dart';

class EditUserProfilePage extends StatelessWidget {
  Stream<QuerySnapshot>? _userStream;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  String _pictureUrl;
  EditUserProfilePage({super.key, required pictureUrl})
      : _pictureUrl = pictureUrl;

  @override
  Widget build(BuildContext context) {
    _firstNameController.text = context.read<AuthBloc>().me!.firstName ?? "";
    _lastNameController.text = context.read<AuthBloc>().me!.lastName ?? "";
    _displayNameController.text =
        context.read<AuthBloc>().me!.displayName ?? "";
    _userStream = FirebaseFirestore.instance.collection('users').snapshots();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<UploadImageBloc, UploadImageState>(
            builder: (context, state) {
              if (state is UploadingSuccessfulState) {
                _pictureUrl = context.read<UploadImageBloc>().uploadedImageUrl!;
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                child: AddPictureWidget(
                  backgroundColor: Colors.grey,
                  radius: 60,
                  iconSize: 60,
                  avatarUrl: _pictureUrl,
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                ),
              );
            },
          ),
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
          BlocListener<UpdateUserProfileBloc, UpdateUserProfileState>(
            listener: (context, state) {
              if (state is UpdateUserProfileErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Error al actualizar datos de la cuenta",
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
              child: BasicElevatedButton(
                label: "ACTUALIZAR CUENTA",
                onPressed: () {
                  log(_lastNameController.text.trim());
                  context.read<UpdateUserProfileBloc>().add(
                        UpdateNewUserProfileInfoEvent(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          displayName: _displayNameController.text.trim(),
                          imageUrl: _pictureUrl,
                          uid: context.read<AuthBloc>().me!.uid,
                        ),
                      );
                },
              ),
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