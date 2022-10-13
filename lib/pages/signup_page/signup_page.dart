import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/components/add_picture_widget.dart';
import 'package:tuks_divide/components/basic_elevated_button.dart';
import 'package:tuks_divide/components/text_input_field.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
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
          title: const Text("Regístrate"), automaticallyImplyLeading: false),
      body: Column(
        children: [
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
            TextInputField(inputController: _nameController, label: "Nombre"),
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
              padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
              child: BasicElevatedButton(
                label: "CREAR CUENTA",
                onPressed: () {},
              )),
        ],
      ),
    );
  }

  Padding _createInputField(TextInputField input) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0), child: input);
  }
}
