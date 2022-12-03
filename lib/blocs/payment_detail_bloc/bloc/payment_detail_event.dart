part of 'payment_detail_bloc.dart';

abstract class PaymentDetailEvent extends Equatable {
  const PaymentDetailEvent();

  @override
  List<Object> get props => [];
}

class GetPaymentDetailEvent extends PaymentDetailEvent {
  final PaymentModel payment;

  const GetPaymentDetailEvent({required this.payment});

  @override
  List<Object> get props => [payment];
}
