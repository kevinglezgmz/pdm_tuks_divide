part of 'payments_bloc.dart';

abstract class PaymentsState extends Equatable {
  const PaymentsState();
  
  @override
  List<Object> get props => [];
}

class PaymentsInitial extends PaymentsState {}
