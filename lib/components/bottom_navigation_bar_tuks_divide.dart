import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/pages/group_profile_activity_page/group_profile_activity_page.dart';
import 'package:tuks_divide/pages/my_groups_page/my_groups_page.dart';

class BottomNavigationBarTuksDivide extends StatefulWidget {
  const BottomNavigationBarTuksDivide({super.key});

  @override
  State<BottomNavigationBarTuksDivide> createState() =>
      _BottomNavigationBarTuksDivideState();
}

class _BottomNavigationBarTuksDivideState
    extends State<BottomNavigationBarTuksDivide> {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuks Divide'),
      ),
      body: IndexedStack(
        index: index,
        children: const [
          MyGroupsPage(),
          MyGroupsPage(),
          GroupProfileActivityPage(),
          GroupProfileActivityPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
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
