import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatelessWidget {
  var _nameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _repeatPasswordController = TextEditingController();
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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 60,
                  child: FaIcon(
                    // TODO: Implement logic to change if user adds image to profile
                    FontAwesomeIcons.userAstronaut,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                Positioned(
                  right: -10.0,
                  bottom: -10.0,
                  child: FloatingActionButton(
                    onPressed: () => {},
                    child: const Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(label: Text("Nombre")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            child: TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(label: Text("Apellido")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(label: Text("Email")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(label: Text("Contraseña")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            child: TextField(
              controller: _repeatPasswordController,
              obscureText: true,
              decoration:
                  const InputDecoration(label: Text("Repetir contraseña")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  )),
              child: const Text("CREAR CUENTA"),
            ),
          ),
        ],
      ),
    );
  }
}
