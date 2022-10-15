import 'package:flutter/material.dart';
import 'package:tuks_divide/utils/text_input_utils.dart';

class PayDebtPage extends StatelessWidget {
  final TextEditingController _moneyController = TextEditingController();
  PayDebtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir pago'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 36,
                child: Icon(
                  Icons.person,
                  color: Colors.black87,
                  size: 58,
                ),
              ),
              SizedBox(width: 16),
              Icon(
                Icons.arrow_forward,
                size: 58,
              ),
              SizedBox(width: 16),
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 36,
                child: Icon(
                  Icons.person,
                  color: Colors.black87,
                  size: 58,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          const Text(
            'Registrando pago a Persona',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.fromLTRB(64, 0, 64, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 36,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _moneyController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 20),
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(fontSize: 20),
                      contentPadding: EdgeInsets.only(top: 14),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 48),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {},
                  child: Ink(
                    color: Colors.grey,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 28,
                      ),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Añadir imagen del pago',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
