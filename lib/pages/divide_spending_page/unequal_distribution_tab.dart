import 'package:flutter/material.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/add_spending_page/add_spending_page.dart';
import 'package:tuks_divide/utils/text_input_utils.dart';

class UnequalDistributionTab extends StatefulWidget {
  final UnequalDivideSpendingTabController controller;
  final double totalAmount;
  const UnequalDistributionTab(
      {super.key, required this.controller, required this.totalAmount});

  @override
  State<UnequalDistributionTab> createState() => _UnequalDistributionTabState();
}

class _UnequalDistributionTabState extends State<UnequalDistributionTab> {
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
                  Icon(Icons.incomplete_circle_outlined, size: 48),
                  Icon(Icons.two_k, size: 48),
                  Icon(Icons.three_k, size: 48),
                  Icon(Icons.four_k, size: 48),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Dividir en partes desiguales',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Introduce la cantidad exacta que cada uno de los miembros debe pagar.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.controller.controllers.length,
            itemBuilder: (BuildContext context, int index) {
              return _getUnequalPriceTile(
                context,
                widget.controller.controllers.entries.toList()[index],
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
                    '\$${widget.controller.totalValueOfDistribution().toStringAsFixed(2)} de \$${widget.totalAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Text(
                    '${(widget.totalAmount - widget.controller.totalValueOfDistribution()) < 0 ? '-' : ''}\$${(widget.totalAmount - widget.controller.totalValueOfDistribution()).abs().toStringAsFixed(2)} restante'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ListTile _getUnequalPriceTile(
    BuildContext context,
    MapEntry<UserModel, TextEditingController> userToUnEqualDistributionAmount,
  ) {
    final UserModel user = userToUnEqualDistributionAmount.key;
    final TextEditingController controller =
        userToUnEqualDistributionAmount.value;
    return ListTile(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: user.pictureUrl == null || user.pictureUrl == ""
                ? const NetworkImage(
                    "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                  )
                : NetworkImage(user.pictureUrl!),
          ),
          const SizedBox(width: 16),
          Text(user.displayName ?? user.fullName ?? '<No username>'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text('\$ '),
          ),
          Center(
            child: SizedBox(
              height: 28,
              width: 50,
              child: TextFormField(
                controller: controller,
                onChanged: (String val) {
                  setState(() {});
                },
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: '0.00',
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
        ],
      ),
    );
  }
}
