import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:intl/intl.dart';

class GroupGraphPage extends StatelessWidget {
  final dateFormat = DateFormat.MMMM('es');
  GroupGraphPage({super.key});

  List<Color> colors = <Color>[
    const Color(0xff114b5f),
    const Color(0xff217180),
    const Color(0xff43bba5),
    const Color(0xff70dcb9),
    const Color(0xffc6dabf),
    const Color(0xfff3e9a2),
    const Color(0xfff3e9d2),
    const Color(0xffe1cd3a),
    const Color(0xff4fc663),
    const Color(0xff6ca753),
    const Color(0xffa1e8af),
    const Color(0xff43aabb),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupsBloc, GroupsUseState>(
        builder: (context, state) {
          if (state.selectedGroup != null &&
              state.payments.isNotEmpty &&
              state.spendings.isNotEmpty) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(state.selectedGroup!.groupName),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SfCircularChart(
                          title: ChartTitle(
                              text: "Total de gastos y pagos del grupo"),
                          legend: Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                              dataSource: _createChartData(
                                  state.spendings, state.payments),
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelMapper: (ChartData data, _) => data.text,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              enableTooltip: true,
                            )
                          ]),
                      SfCircularChart(
                          title: ChartTitle(text: "Total de gastos por mes"),
                          legend: Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                              dataSource:
                                  _getTotalSpendingsByMonth(state.spendings),
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelMapper: (ChartData data, _) => data.text,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              enableTooltip: true,
                            )
                          ]),
                      SfCircularChart(
                          title: ChartTitle(text: "Total de pagos por mes"),
                          legend: Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                              dataSource:
                                  _getTotalPaymentsByMonth(state.payments),
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelMapper: (ChartData data, _) => data.text,
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              enableTooltip: true,
                            )
                          ])
                    ],
                  ),
                ));
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Finanzas del grupo"),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text("Ups! No encontramos las finanzas del grupo"),
                )
              ],
            ),
          );
        },
        listener: (context, state) {});
  }

  double _getGroupTotalSpendings(List<SpendingModel> spendings) {
    double total = 0;
    for (var spending in spendings) {
      total += spending.amount;
    }
    return total;
  }

  double _getGroupTotalPayments(List<PaymentModel> payments) {
    double total = 0;
    for (var payment in payments) {
      total += payment.amount;
    }
    return total;
  }

  List<ChartData> _createChartData(
      List<SpendingModel> spendings, List<PaymentModel> payments) {
    double paymentsTotal = _getGroupTotalPayments(payments);
    double spendingsTotal = _getGroupTotalSpendings(spendings);
    double total = paymentsTotal + spendingsTotal;
    List<ChartData> data = [
      ChartData("Gastos", spendingsTotal,
          "${(spendingsTotal * 100 / total).toStringAsFixed(1)}%", colors[1]),
      ChartData("Pagos", paymentsTotal,
          "${(paymentsTotal * 100 / total).toStringAsFixed(1)}%", colors[2])
    ];
    return data;
  }

  List<ChartData> _getTotalPaymentsByMonth(List<PaymentModel> payments) {
    List<ChartData> paymentsByMonth = [];
    double total = _getGroupTotalPayments(payments);
    for (var i = 0; i < 12; i++) {
      double monthTotal = _getMonthTotalPayment(payments, i + 1);
      String month = dateFormat.format(DateTime(2022, i + 1));
      if (monthTotal > 0) {
        paymentsByMonth.add(ChartData(
            month[0].toUpperCase() + month.substring(1),
            monthTotal,
            "${(monthTotal * 100 / total).toStringAsFixed(1)}%",
            colors[i]));
      }
    }
    return paymentsByMonth;
  }

  List<ChartData> _getTotalSpendingsByMonth(List<SpendingModel> spendings) {
    List<ChartData> spendingsByMonth = [];
    double total = _getGroupTotalSpendings(spendings);
    for (var i = 0; i < 12; i++) {
      double monthTotal = _getMonthTotalSpending(spendings, i + 1);
      String month = dateFormat.format(DateTime(2022, i + 1));
      if (monthTotal > 0) {
        spendingsByMonth.add(ChartData(
            month[0].toUpperCase() + month.substring(1),
            monthTotal,
            "${(monthTotal * 100 / total).toStringAsFixed(1)}%",
            colors[i]));
      }
    }
    return spendingsByMonth;
  }

  double _getMonthTotalSpending(List<SpendingModel> spendings, int month) {
    double total = 0;
    List<SpendingModel> spendingsOfTheMonth = spendings
        .where((spending) => spending.createdAt.toDate().month == month)
        .toList();
    for (var spending in spendingsOfTheMonth) {
      total += spending.amount;
    }
    return total;
  }

  double _getMonthTotalPayment(List<PaymentModel> payments, int month) {
    double total = 0;
    List<PaymentModel> paymentsOfTheMonth = payments
        .where((payment) => payment.createdAt.toDate().month == month)
        .toList();
    for (var spending in paymentsOfTheMonth) {
      total += spending.amount;
    }
    return total;
  }
}

class ChartData {
  ChartData(this.x, this.y, this.text, this.color);
  final String x;
  final double y;
  final String text;
  final Color color;
}
