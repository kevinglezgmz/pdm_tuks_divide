import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/components/basic_elevated_button.dart';
import 'package:tuks_divide/components/elevated_button_with_icon.dart';
import 'package:tuks_divide/components/text_input_field.dart';
import 'package:tuks_divide/pages/signup_page/signup_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tuks Divide')),
      body: Column(
        children: [
          _addWidgetWithPadding(
            35.0,
            8.0,
            TextInputField(inputController: _emailController, label: "Email"),
          ),
          _addWidgetWithPadding(
              8.0,
              8.0,
              TextInputField(
                  inputController: _passwordController,
                  label: "Contraseña",
                  obscureText: true)),
          _addWidgetWithPadding(
              18.0,
              30.0,
              BasicElevatedButton(
                label: "INICIAR SESIÓN",
                onPressed: () {},
              )),
          _addWidgetWithPadding(
            8.0,
            30.0,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _createDivider(context),
                const Text("O"),
                _createDivider(context)
              ],
            ),
          ),
          _addWidgetWithPadding(
              8.0,
              8.0,
              ElevatedButtonWithIcon(
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthGoogleLoginEvent());
                  },
                  label: "INICIAR SESIÓN CON GOOGLE",
                  backgroundColor:
                      const Color.fromARGB(0xFF, 0xDC, 0x4E, 0x41))),
          _addWidgetWithPadding(
            50.0,
            15.0,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿No tienes una cuenta? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: const Text(
                    "Crear una cuenta",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding _addWidgetWithPadding(double top, double bottom, Widget widget) {
    return Padding(
        padding: EdgeInsets.fromLTRB(15.0, top, 15.0, bottom), child: widget);
  }

  Flexible _createDivider(BuildContext context) {
    return Flexible(
      child: Divider(
        thickness: 1,
        indent: MediaQuery.of(context).size.width / 20,
        endIndent: MediaQuery.of(context).size.width / 20,
      ),
    );
  }
}
