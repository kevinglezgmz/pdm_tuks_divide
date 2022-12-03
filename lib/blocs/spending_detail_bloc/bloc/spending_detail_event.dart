part of 'spending_detail_bloc.dart';

abstract class SpendingDetailEvent extends Equatable {
  const SpendingDetailEvent();

  @override
  List<Object> get props => [];
}

class GetSpendingDetailEvent extends SpendingDetailEvent {
  final SpendingModel spending;

  const GetSpendingDetailEvent({required this.spending});

  @override
  List<Object> get props => [spending];
}
