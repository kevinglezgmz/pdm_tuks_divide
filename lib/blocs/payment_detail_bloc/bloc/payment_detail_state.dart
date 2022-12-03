part of 'payment_detail_bloc.dart';

abstract class PaymentDetailState extends Equatable {
  const PaymentDetailState();

  @override
  List<Object> get props => [];
}

class PaymentDetailInitialState extends PaymentDetailState {}

class PaymentLoadingDetailState extends PaymentDetailState {}

class PaymentLoadingErrorState extends PaymentDetailState {}

class PaymentLoadedDetailState extends PaymentDetailState {
  final PaymentModel payment;
  final UserModel payer;
  final UserModel receiver;

  const PaymentLoadedDetailState(
      {required this.payment, required this.payer, required this.receiver});

  @override
  List<Object> get props => [payment, payer, receiver];
}
