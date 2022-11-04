import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/components/add_picture_widget.dart';
import 'package:tuks_divide/components/basic_elevated_button.dart';
import 'package:tuks_divide/components/text_input_field.dart';
import 'package:tuks_divide/models/user_model.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
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
            BlocListener(listener: (context, state) {
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
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
              child: AddPictureWidget(
                backgroundColor: Colors.grey,
                radius: 60,
                iconSize: 60,
                onPressed: () {},
              ),
            ),
            _createInputField(
              TextInputField(
                  inputController: _firstNameController, label: "Nombre"),
            ),
            _createInputField(
              TextInputField(
                  inputController: _lastNameController, label: "Apellido"),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
              child: BasicElevatedButton(
                label: "CREAR CUENTA",
                onPressed: () {
                  context.read<AuthBloc>().add(
                        AuthEmailSignupEvent(
                          newUser: UserModel(
                            displayName: '',
                            pictureUrl: null,
                            lastName: _lastNameController.text.trim(),
                            firstName: _firstNameController.text.trim(),
                            email: _emailController.text.trim(),
                            uid: '',
                          ),
                          password: _passwordController.text,
                        ),
                      );
                },
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
}
