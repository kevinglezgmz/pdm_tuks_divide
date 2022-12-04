import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/payment_detail_bloc/bloc/payment_detail_bloc.dart';
import 'package:intl/intl.dart';

class PaymentDetailPage extends StatelessWidget {
  final dateFormat = DateFormat.MMMM('es');
  PaymentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentDetailBloc, PaymentDetailState>(
        builder: (context, state) {
          if (state is PaymentLoadedDetailState) {
            final date = state.payment.createdAt.toDate();
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
                        "\$${state.payment.amount}",
                        style: const TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        state.payment.description,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 20),
                      child: Column(
                        children: [
                          Text(
                            "Pagado por ${state.payer.displayName ?? state.payer.fullName ?? "<No Name>"}",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Recibió ${state.receiver.displayName ?? state.receiver.fullName ?? "<No Name>"}",
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
                            child: state.payment.paymentPic == null ||
                                    state.payment.paymentPic == ""
                                ? Image.network(
                                    "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                                    fit: BoxFit.fill)
                                : Image.network(state.payment.paymentPic!,
                                    fit: BoxFit.fill))),
                  ],
                ));
          }
          if (state is PaymentLoadingDetailState) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Detalle de pago"),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ));
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text("Detalle de pago"),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text("Ups! No encontramos el pago"),
                  )
                ],
              ));
        },
        listener: (context, state) {});
  }
}
