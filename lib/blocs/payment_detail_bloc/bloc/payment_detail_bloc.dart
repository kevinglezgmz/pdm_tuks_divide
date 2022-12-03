import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'payment_detail_event.dart';
part 'payment_detail_state.dart';

class PaymentDetailBloc extends Bloc<PaymentDetailEvent, PaymentDetailState> {
  PaymentDetailBloc() : super(PaymentDetailInitialState()) {
    on<GetPaymentDetailEvent>(_getPaymentDetailEventHandler);
  }
  FutureOr<void> _getPaymentDetailEventHandler(event, emit) async {
    emit(PaymentLoadingDetailState());
    try {
      final payer = await event.payment.payer.get();
      final receiver = await event.payment.receiver.get();
      emit(PaymentLoadedDetailState(
          payer: payer, receiver: receiver, payment: event.payment));
    } catch (error) {
      emit(PaymentLoadingErrorState());
    }
  }
}
