import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseItem extends StatelessWidget {
  final String month;
  final String day;
  final String expenseTitle;
  final String expenseDescription;
  const ExpenseItem(
      {super.key,
      required this.month,
      required this.day,
      required this.expenseTitle,
      required this.expenseDescription});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              month,
              textAlign: TextAlign.center,
            ),
            Text(
              day,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            )
          ],
        ),
        title: Text(
          expenseTitle,
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          expenseDescription,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const FaIcon(FontAwesomeIcons.receipt),
      ),
    );
  }
}
