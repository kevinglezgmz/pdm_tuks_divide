import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/user_model.dart';

class PaymentDetailPage extends StatelessWidget {
  final PaymentModel payment;
  final UserModel payer;
  final UserModel receiver;
  PaymentDetailPage({
    super.key,
    required this.payment,
    required this.payer,
    required this.receiver,
  });
  final dateFormat = DateFormat.MMMM('es');

  @override
  Widget build(BuildContext context) {
    final date = payment.createdAt.toDate();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Detalle de pago"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
              child: Text(
                "\$${payment.amount}",
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                payment.description,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 20),
              child: Column(
                children: [
                  Text(
                    "Pagado por ${payer.displayName ?? payer.fullName ?? "<No Name>"}",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Recibió ${receiver.displayName ?? receiver.fullName ?? "<No Name>"}",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Fecha: ${date.day} de ${dateFormat.format(date)} del ${date.year}",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
              child: Text(
                "Comprobante de pago",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 30),
                    child: payment.paymentPic == null ||
                            payment.paymentPic == ""
                        ? Image.network(
                            "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                            fit: BoxFit.fill)
                        : Image.network(payment.paymentPic!,
                            fit: BoxFit.fill))),
          ],
        ));
  }
}
