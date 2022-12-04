import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/payments_bloc/bloc/payments_repository.dart';
import 'package:tuks_divide/models/group_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/utils/text_input_utils.dart';

class PayDebtPage extends StatefulWidget {
  final UserModel sender;
  final UserModel receiver;
  final GroupModel group;
  const PayDebtPage({
    super.key,
    required this.sender,
    required this.receiver,
    required this.group,
  });

  @override
  State<PayDebtPage> createState() => _PayDebtPageState();
}

class _PayDebtPageState extends State<PayDebtPage> {
  final TextEditingController _moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir pago'),
        actions: [
          IconButton(
            onPressed: () {
              double? amount = double.tryParse(_moneyController.text);
              if (amount == null) {
                return;
              }
              RepositoryProvider.of<PaymentsRepository>(context)
                  .addPaymentDetail(
                amount,
                "Descripcion temporal",
                widget.sender,
                widget.receiver,
                null,
                widget.group,
              )
                  .then((value) {
                if (value != null) {
                  Navigator.of(context).pop();
                }
              });
            },
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
            children: [
              CircleAvatar(
                backgroundImage: widget.sender.pictureUrl == null ||
                        widget.sender.pictureUrl == ""
                    ? const NetworkImage(
                        "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                    : NetworkImage(widget.sender.pictureUrl!),
                radius: 48,
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.arrow_forward,
                size: 58,
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                backgroundImage: widget.receiver.pictureUrl == null ||
                        widget.receiver.pictureUrl == ""
                    ? const NetworkImage(
                        "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png")
                    : NetworkImage(widget.receiver.pictureUrl!),
                radius: 48,
              ),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            'Registrando pago a ${widget.receiver.displayName ?? widget.receiver.fullName ?? '<Sin Nombre>'}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
