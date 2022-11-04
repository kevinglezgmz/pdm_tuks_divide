import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/pages/home_page/group_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
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
      Positioned(
        right: 15.0,
        bottom: 15.0,
        child: FloatingActionButton(
          onPressed: () {},
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
      )
    ]);
  }
}
