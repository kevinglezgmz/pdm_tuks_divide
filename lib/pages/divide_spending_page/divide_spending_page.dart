import 'package:flutter/material.dart';
import 'package:tuks_divide/utils/text_input_utils.dart';

class DivideSpendingPage extends StatelessWidget {
  const DivideSpendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Ajustar gasto',
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.check,
                  ))
            ],
            bottom: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                indicatorColor: Colors.white,
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
                ]),
          ),
          body: TabBarView(
            children: [
              _getEqualDistribution(),
              _getUnequalDistribution(),
              _getPercentageDistribution(),
            ],
          )),
    );
  }

  Widget _getEqualDistribution() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Selecciona las personas que deben pagar la misma cantidad en este gasto.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                _getEqualPriceCheckboxTile(),
                _getEqualPriceCheckboxTile(),
                _getEqualPriceCheckboxTile(),
                _getEqualPriceCheckboxTile(),
                _getEqualPriceCheckboxTile(),
                _getEqualPriceCheckboxTile(),
                _getEqualPriceCheckboxTile(),
                _getEqualPriceCheckboxTile(),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              flex: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('\$0.00/persona'),
                  Text('(8 personas)'),
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
                value: true,
                onChanged: (value) {},
              ),
            )
          ],
        )
      ],
    );
  }

  CheckboxListTile _getEqualPriceCheckboxTile() {
    return CheckboxListTile(
      value: true,
      onChanged: (newValue) {},
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                "https://via.placeholder.com/150",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Miembro 1'),
        ],
      ),
    );
  }

  ListTile _getUnequalPriceTile() {
    TextEditingController unequalPartPriceController = TextEditingController();
    return ListTile(
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                "https://via.placeholder.com/150",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Miembro 1'),
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
                controller: unequalPartPriceController,
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
          )
        ],
      ),
    );
  }

  Widget _getUnequalDistribution() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Introduce la cantidad exacta que cada uno de los miembros debe pagar.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                _getUnequalPriceTile(),
                _getUnequalPriceTile(),
                _getUnequalPriceTile(),
                _getUnequalPriceTile(),
                _getUnequalPriceTile(),
                _getUnequalPriceTile(),
                _getUnequalPriceTile(),
                _getUnequalPriceTile(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('\$0.00 de \$45.25'),
                Text('\$45.25 restante'),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _getPercentageDistribution() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Introduce el porcentaje que le toca pagar a cada uno de los miembros.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                _getPercentageTile(),
                _getPercentageTile(),
                _getPercentageTile(),
                _getPercentageTile(),
                _getPercentageTile(),
                _getPercentageTile(),
                _getPercentageTile(),
                _getPercentageTile(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('0% de 100%'),
                Text('100% restante'),
              ],
            ),
          ),
        )
      ],
    );
  }

  ListTile _getPercentageTile() {
    TextEditingController unequalPartPriceController = TextEditingController();
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            "https://via.placeholder.com/150",
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: const Text('Miembro 1'),
      subtitle: const Text('\$0.00'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              height: 28,
              width: 40,
              child: TextFormField(
                controller: unequalPartPriceController,
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
