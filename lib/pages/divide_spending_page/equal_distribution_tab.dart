import 'package:flutter/material.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/add_spending_page/add_spending_page.dart';

class EqualDistributionTab extends StatefulWidget {
  final EqualDivideSpendingTabController controller;
  final double totalAmount;
  const EqualDistributionTab({
    super.key,
    required this.controller,
    required this.totalAmount,
  });

  @override
  State<EqualDistributionTab> createState() => _EqualDistributionTabState();
}

class _EqualDistributionTabState extends State<EqualDistributionTab> {
  set allSelected(bool allSelected) {
    for (final UserModel user in widget.controller.controllers.keys) {
      widget.controller.controllers[user] = allSelected;
    }
  }

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
                  Icon(Icons.calendar_view_month_outlined, size: 48),
                  Icon(Icons.two_k, size: 48),
                  Icon(Icons.three_k, size: 48),
                  Icon(Icons.four_k, size: 48),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Dividir en partes iguales',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Selecciona las personas que deben pagar la misma cantidad en este gasto.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.controller.controllers.entries.length,
            itemBuilder: (BuildContext context, int index) {
              final List<MapEntry<UserModel, bool>> entries =
                  widget.controller.controllers.entries.toList();
              return _getEqualPriceCheckboxTile(
                context,
                entries[index],
              );
            },
          ),
        ),
        SizedBox(
          height: 56,
          child: Row(
            children: [
              Expanded(
                flex: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '\$${widget.controller.numberOfParticipants() > 0 ? (widget.totalAmount / widget.controller.numberOfParticipants()).toStringAsFixed(2) : '0.00'}/persona'),
                    const SizedBox(height: 4),
                    Text(
                        '(${widget.controller.numberOfParticipants()} personas)'),
                  ],
                ),
              ),
              Expanded(
                flex: 40,
                child: CheckboxListTile(
                  title: const Text(
                    'Todos',
                    textAlign: TextAlign.end,
                  ),
                  value: widget.controller.allParticipantsSelected(),
                  onChanged: (value) {
                    setState(() {
                      allSelected = value == true;
                    });
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  CheckboxListTile _getEqualPriceCheckboxTile(
      BuildContext context, MapEntry<UserModel, bool> userData) {
    final UserModel user = userData.key;
    final bool? isIncluded = widget.controller.controllers[user];
    return CheckboxListTile(
      value: isIncluded,
      onChanged: (newValue) {
        setState(() {
          widget.controller.controllers[user] = newValue == true;
        });
      },
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
    );
  }
}
