import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/pages/create_group_page/member_list.dart';

class CreateGroupPage extends StatelessWidget {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController =
      TextEditingController();
  CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.xmark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Crear un grupo"),
        actions: [
          TextButton(
            onPressed: () {},
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
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(clipBehavior: Clip.none, children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 45,
                  child: FaIcon(
                    FontAwesomeIcons.userAstronaut,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                Positioned(
                  height: 45,
                  width: 45,
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
              ]),
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
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 8.0, 19.0, 8.0),
          child: TextField(
            controller: _groupDescriptionController,
            decoration: const InputDecoration(label: Text("Descripción")),
            maxLength: 120,
            maxLines: 3,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Miembros del grupo",
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 20.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.userPlus),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.0),
                )),
            label: const Text("AÑADIR MIEMBRO"),
          ),
        ),
        MemberList()
      ]),
    );
  }
}