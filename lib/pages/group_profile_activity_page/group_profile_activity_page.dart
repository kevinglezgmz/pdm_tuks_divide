import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';

class GroupProfileActivityPage extends StatelessWidget {
  const GroupProfileActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividad de Kevin'),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const SizedBox(width: double.infinity, height: double.infinity),
          Container(
            height: 128,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.4,
                  0.70,
                  1,
                ],
                colors: [
                  Colors.yellow,
                  Colors.red,
                  Colors.indigo,
                  Colors.teal,
                ],
              ),
            ),
          ),
          const Positioned(
            top: 128 - 48,
            right: 0,
            left: 0,
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.indigo,
              child: Icon(
                Icons.person,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 128 + 48,
            right: 0,
            left: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 16),
                Text(
                  'Kevin González',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Debe \$150.58',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Le deben \$25.58',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 284,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  _getActivityTile('Paletas con forma de Mickey',
                      'Kevin realizó un pago de \$10.00'),
                  _getActivityTile(
                      'Compras de ropa', 'Kevin debe \$150.58 a Andrea'),
                  _getActivityTile(
                      'Churros con cajeta', 'Kevin realizó un pago de \$15.58'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _createActivityList(List<PaymentModel> paymentRefs,
      List<PaymentModel> debtRefs, List<SpendingModel> spentRefs) {
    List<Widget> activityList = [];
    int totalActivityItems =
        debtRefs.length + debtRefs.length + spentRefs.length;
    int paymentIdx = 0;
    int debtIdx = 0;
    int spentIdx = 0;
    DateTime currMonth = DateTime.now();

    for (int item = 0; item < totalActivityItems; item++) {
      String title = "";
      String subtitle = "";
      dynamic activity = _getLatestActivity(
          paymentRefs[paymentIdx], debtRefs[debtIdx], spentRefs[spentIdx]);

      if (item == 0 || activity.createdAt.toDate().month != currMonth.month) {
        currMonth = activity.createdAt.toDate();
        activityList.add(_getActivityDateDivider(
            DateFormat("MMMM").format(currMonth), currMonth.year));
      }
      //get name of spen
      if (activity == paymentRefs[paymentIdx]) {
        title = activity.activityList.add(_getActivityTile(title, subtitle));
        paymentIdx++;
      } else if (activity == debtRefs[debtIdx]) {
        debtIdx++;
      } else {
        spentIdx++;
      }
    }
    return activityList;
  }

  dynamic _getLatestActivity(
      PaymentModel payment, PaymentModel debt, SpendingModel spending) {
    if (payment.createdAt.millisecondsSinceEpoch >
            debt.createdAt.millisecondsSinceEpoch &&
        payment.createdAt.millisecondsSinceEpoch >
            spending.createdAt.millisecondsSinceEpoch) {
      return payment;
    } else if (debt.createdAt.millisecondsSinceEpoch >
        spending.createdAt.millisecondsSinceEpoch) {
      return debt;
    }
    return spending;
  }

  Widget _getActivityDateDivider(String month, int year) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Text(
        '$month del $year',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getActivityTile(String title, String subtitle) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Text(
                'oct.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              Text(
                '13',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        minLeadingWidth: 28,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.attach_money),
      ),
    );
  }
}
