import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:tuks_divide/components/image_viewer.dart';
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
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Text(
                "Total: \$${payment.amount.toStringAsFixed(2)}",
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Text(
                "Concepto: ${payment.description}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                    "Pagado por: ${payer.displayName ?? payer.fullName ?? "<No Name>"}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Recibido por: ${receiver.displayName ?? receiver.fullName ?? "<No Name>"}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Fecha: ${date.day} de ${dateFormat.format(date)} del ${date.year}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
              child: Text(
                "Comprobante del pago:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Material(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(90, 20, 90, 30),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImageViewerPage(
                              imageUrl: payment.paymentPic == null ||
                                      payment.paymentPic == ""
                                  ? "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png"
                                  : payment.paymentPic!),
                        ),
                      );
                    },
                    child:
                        payment.paymentPic == null || payment.paymentPic == ""
                            ? Ink.image(
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: const NetworkImage(
                                  "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                                ))
                            : Ink.image(
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: NetworkImage(payment.paymentPic!),
                              ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ));
  }
}
