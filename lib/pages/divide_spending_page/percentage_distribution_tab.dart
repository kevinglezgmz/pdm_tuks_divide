import 'package:flutter/material.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/add_spending_page/add_spending_page.dart';
import 'package:tuks_divide/utils/text_input_utils.dart';

class PercentageDistributionTab extends StatefulWidget {
  final PercentageDivideSpendingTabController controller;
  final double totalAmount;
  const PercentageDistributionTab({
    super.key,
    required this.controller,
    required this.totalAmount,
  });

  @override
  State<PercentageDistributionTab> createState() =>
      _PercentageDistributionTabState();
}

class _PercentageDistributionTabState extends State<PercentageDistributionTab> {
  final percentTarget = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(Icons.percent, size: 48),
                  Icon(Icons.two_k, size: 48),
                  Icon(Icons.three_k, size: 48),
                  Icon(Icons.four_k, size: 48),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Dividir por porcentajes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Introduce el porcentaje que le toca pagar a cada uno de los miembros.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.controller.controllers.entries.length,
            itemBuilder: (BuildContext context, int index) {
              final List<MapEntry<UserModel, TextEditingController>> entries =
                  widget.controller.controllers.entries.toList();
              return _getPercentageTile(
                context,
                entries[index],
              );
            },
          ),
        ),
        SizedBox(
          height: 56,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '${widget.controller.accumulatedPercent().toStringAsFixed(2)}% de 100%'),
                const SizedBox(height: 4),
                Text(_getRemainingText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String get _getRemainingText {
    double remainingAmount =
        percentTarget - widget.controller.accumulatedPercent();
    if (remainingAmount < 0) {
      return '${remainingAmount.abs().toStringAsFixed(2)}% de más';
    }
    return '${remainingAmount.abs().toStringAsFixed(2)}% restante';
  }

  ListTile _getPercentageTile(
    BuildContext context,
    MapEntry<UserModel, TextEditingController> userToPercentDistributionAmount,
  ) {
    final UserModel user = userToPercentDistributionAmount.key;
    final TextEditingController controller =
        userToPercentDistributionAmount.value;
    double? percentage = double.tryParse(
      controller.text,
    );
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.pictureUrl == null || user.pictureUrl == ""
            ? const NetworkImage(
                "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
              )
            : NetworkImage(user.pictureUrl!),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(user.displayName ?? user.fullName ?? '<No username>'),
          Text(
            '\$${percentage != null && percentage > 0 && widget.totalAmount > 0 ? (percentage * widget.totalAmount / 100).toStringAsFixed(2) : '0.00'}',
            style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 13),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              height: 28,
              width: 40,
              child: TextFormField(
                controller: controller,
                onChanged: (value) {
                  setState(() {});
                },
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: EdgeInsets.only(
                    bottom: 13,
                  ),
                ),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const Center(
            child: Text(' %'),
          ),
        ],
      ),
    );
  }
}
