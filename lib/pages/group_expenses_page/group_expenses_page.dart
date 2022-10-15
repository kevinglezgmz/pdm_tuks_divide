import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuks_divide/pages/group_expenses_page/expense_list.dart';

class GroupExpensesPage extends StatelessWidget {
  const GroupExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              color: Colors.cyan[200],
              height: MediaQuery.of(context).size.height / 6,
            ),
            Positioned(
              left: 30,
              bottom: -40,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink[100],
                ),
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(40.0, 50.0, 0.0, 8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Disney Trip",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(40.0, 8.0, 0.0, 8.0),
          child: Column(
            children: [
              Row(
                children: const [
                  Text(
                    "Juan Pérez te debe ",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text("\$65.32",
                      style: TextStyle(fontSize: 16, color: Colors.blue))
                ],
              ),
              Row(
                children: const [
                  Text("Debes a Andrea ",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text("\$150.36",
                      style: TextStyle(fontSize: 16, color: Colors.blue))
                ],
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Septiembre 2021",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ExpenseList()
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
