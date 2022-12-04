import 'package:flutter/material.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/pages/add_spending_page/add_spending_page.dart';
import 'package:tuks_divide/pages/divide_spending_page/equal_distribution_tab.dart';
import 'package:tuks_divide/pages/divide_spending_page/percentage_distribution_tab.dart';
import 'package:tuks_divide/pages/divide_spending_page/unequal_distribution_tab.dart';

class DivideSpendingPage extends StatefulWidget {
  final DistributionType initialDistributionType;
  final EqualDivideSpendingTabController equalTabController;
  final UnequalDivideSpendingTabController unequalTabController;
  final PercentageDivideSpendingTabController percentageTabController;
  final double totalAmount;
  const DivideSpendingPage({
    super.key,
    this.initialDistributionType = DistributionType.equal,
    required this.equalTabController,
    required this.unequalTabController,
    required this.percentageTabController,
    required this.totalAmount,
  });

  @override
  State<DivideSpendingPage> createState() => _DivideSpendingPageState();
}

class _DivideSpendingPageState extends State<DivideSpendingPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late DistributionType distributionType;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: DistributionType.values.indexOf(
        widget.initialDistributionType,
      ),
    );
    distributionType = widget.initialDistributionType;
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }
      setState(() {
        distributionType = DistributionType.values[_tabController.index];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ajustar gasto',
          ),
          actions: [
            IconButton(
              onPressed: () {
                _validateDistribution(
                  context,
                  distributionType,
                );
              },
              icon: const Icon(
                Icons.check,
              ),
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.white.withOpacity(0.3),
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: const [
              Tab(
                child: Text('En partes iguales'),
              ),
              Tab(
                child: Text('En partes desiguales'),
              ),
              Tab(
                child: Text('En porcentajes'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            EqualDistributionTab(
              controller: widget.equalTabController,
              totalAmount: widget.totalAmount,
            ),
            UnequalDistributionTab(
              controller: widget.unequalTabController,
              totalAmount: widget.totalAmount,
            ),
            PercentageDistributionTab(
              controller: widget.percentageTabController,
              totalAmount: widget.totalAmount,
            ),
          ],
        ),
      ),
    );
  }

  void _validateDistribution(
    BuildContext context,
    DistributionType spendingDistributionType,
  ) {
    if (distributionType == DistributionType.equal) {
      if (widget.equalTabController.isValidDistribution()) {
        Navigator.of(context).pop(distributionType);
      } else {
        _showDistributionErrorDialog(
          context,
          title: "Distribución no válida",
          message:
              "Debes seleccionar al menos un miembro para realizar la distribución.",
        );
      }
      return;
    }
    if (distributionType == DistributionType.unequal) {
      if (widget.unequalTabController.isValidDistribution(widget.totalAmount)) {
        Navigator.of(context).pop(distributionType);
      } else {
        _showDistributionErrorDialog(
          context,
          title: "Distribución no válida",
          message:
              "La suma total de todos los montos debe ser igual al total del gasto.",
        );
      }
      return;
    }
    if (distributionType == DistributionType.percentage) {
      if (widget.percentageTabController.isValidDistribution()) {
        Navigator.of(context).pop(distributionType);
      } else {
        _showDistributionErrorDialog(
          context,
          title: "Distribución no válida",
          message:
              "La suma total de todos los porcentajes debe sumar cien por ciento.",
        );
      }
      return;
    }
  }

  void _showDistributionErrorDialog(BuildContext context,
      {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Aceptar"),
          )
        ],
      ),
    );
  }
}
