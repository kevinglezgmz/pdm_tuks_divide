import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentDetailPage extends StatelessWidget {
  const PaymentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Detalle de pago"),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ));
        },
        listener: (context, state) {});
  }
}
