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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                      child: Text(
                        "\$${state.payment.amount}",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                      child: Text(
                        state.payment.description,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                      ),
                    ),
                    /*Container(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 30),
                        height: 325,
                        width: 400,
                        child: state.payment.PaymentPic == null ||
                                state.payment.PaymentPic == ""
                            ? Image.network(
                                "https://www.unfe.org/wp-content/uploads/2019/04/SM-placeholder.png",
                                fit: BoxFit.fill)
                            : Image.network(state.payment.PaymentPic!,
                                fit: BoxFit.fill)),*/
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
