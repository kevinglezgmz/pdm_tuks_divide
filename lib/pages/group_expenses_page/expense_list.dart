import 'package:flutter/material.dart';
import 'package:tuks_divide/pages/group_expenses_page/expense_item.dart';

class ExpenseList extends StatelessWidget {
  final List<dynamic> expenseData = [
    {
      "day": "15",
      "month": "sep",
      "expenseTitle": "Paletas con forma de Mickey",
      "expenseDescription": "Pagaste \$95.48"
    },
    {
      "day": "15",
      "month": "sep",
      "expenseTitle": "Pelotas de Pixar",
      "expenseDescription": "Kevin pagó \$105.89"
    },
    {
      "day": "15",
      "month": "sep",
      "expenseTitle": "Café Star Wars",
      "expenseDescription": "Andrea pagó \$96.55"
    }
  ];
  ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: expenseData.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpenseItem(
                day: expenseData[index]["day"],
                month: expenseData[index]["month"],
                expenseTitle: expenseData[index]["expenseTitle"],
                expenseDescription: expenseData[index]["expenseDescription"],
              );
            }));
  }
}
