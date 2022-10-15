import 'package:flutter/material.dart';
import 'package:tuks_divide/utils/text_input_utils.dart';

class AddSpendingPage extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController moneyController = TextEditingController();
  AddSpendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir gasto'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: const [
                Text(
                  'Gasto hecho por tí y: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Selecciona más integrantes',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            Row(
              children: const [
                Text(
                  'que participaron en el gasto',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 32, 40, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 36,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: descriptionController,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Introduce una descripción',
                            hintStyle: TextStyle(fontSize: 16),
                            contentPadding: EdgeInsets.only(top: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(40, 0, 40, 8),
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
                          controller: moneyController,
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
                )
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Gasto pagado por: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Ink(
                      color: Colors.grey,
                      child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          child: Text(
                            'tí',
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'dividido por: ',
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Ink(
                      color: Colors.grey,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 6,
                        ),
                        child: Text(
                          'forma equitativa',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    ' .',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 64,
            ),
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
                    'Añadir imagen del gasto',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
