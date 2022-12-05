import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/components/add_picture_widget.dart';
import 'package:tuks_divide/components/basic_elevated_button.dart';
import 'package:tuks_divide/components/text_input_field.dart';
import 'package:tuks_divide/models/user_model.dart';

class SignupPage extends StatelessWidget {
  String? pictureUrl;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Regístrate"),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<UploadImageBloc, UploadImageState>(
                builder: (context, state) {
              if (state is UploadingSuccessfulState) {
                pictureUrl = context.read<UploadImageBloc>().uploadedImageUrl;
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
                  inputController: _userNameController,
                  label: "Nombre de Usuario"),
            ),
            _createInputField(
              TextInputField(inputController: _emailController, label: "Email"),
            ),
            _createInputField(
              TextInputField(
                inputController: _passwordController,
                label: "Contraseña",
                obscureText: true,
              ),
            ),
            _createInputField(TextInputField(
              inputController: _repeatPasswordController,
              label: "Repetir contraseña",
              obscureText: true,
            )),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoggedInState) {
                  Navigator.of(context).pop();
                } else if (state is AuthNotLoggedInState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Error al registrar usuario",
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
                child: BasicElevatedButton(
                  label: "CREAR CUENTA",
                  onPressed: () {
                    if (_userNameController.text.trim() == '' &&
                        _emailController.text.trim() == '' &&
                        _passwordController.text.trim() == '' &&
                        _repeatPasswordController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Ingresa nombre de usuario para continuar",
                          ),
                        ),
                      );
                      return;
                    }
                    if (_userNameController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Ingresa nombre de usuario para continuar",
                          ),
                        ),
                      );
                      return;
                    }
                    if (_emailController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Ingresa un email para continuar",
                          ),
                        ),
                      );
                      return;
                    }
                    if (_passwordController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Ingresa una contraseña",
                          ),
                        ),
                      );
                      return;
                    }
                    if (_repeatPasswordController.text.trim() == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Repite la contraseña e intenta de nuevo",
                          ),
                        ),
                      );
                      return;
                    }
                    if (_passwordController.text.trim() !=
                        _repeatPasswordController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Las contraseñas no coinciden, intenta de nuevo",
                          ),
                        ),
                      );
                      return;
                    }
                    if (!regex
                        .hasMatch(_repeatPasswordController.text.trim())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Por favor, ingresa una contraseña segura",
                          ),
                        ),
                      );
                      return;
                    }
                    context.read<AuthBloc>().add(
                          AuthEmailSignupEvent(
                            newUser: UserModel(
                              displayName: _userNameController.text.trim(),
                              pictureUrl: pictureUrl,
                              lastName: null,
                              firstName: null,
                              email: _emailController.text.trim(),
                              uid: '',
                            ),
                            password: _passwordController.text,
                          ),
                        );
                  },
                ),
              ),
            ),
          ],
        ),
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
                  .add(const UploadNewImageEvent("users", "gallery"));
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
                  .add(const UploadNewImageEvent("users", "camera"));
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
