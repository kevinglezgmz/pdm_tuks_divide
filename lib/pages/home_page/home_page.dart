import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/pages/home_page/group_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.group_add))
      ]),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 10.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Tus grupos",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GroupList(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Grupos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Amigos"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.chartLine), label: "Actividad"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userAstronaut), label: "Cuenta")
        ],
      ),
    );
  }
}
