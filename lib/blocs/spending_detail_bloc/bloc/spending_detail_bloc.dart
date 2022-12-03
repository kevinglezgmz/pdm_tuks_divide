import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_repository.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'spending_detail_event.dart';
part 'spending_detail_state.dart';

class SpendingDetailBloc
    extends Bloc<SpendingDetailEvent, SpendingDetailState> {
  final SpendingDetailRepository _spendingDetailRepository;
  SpendingDetailBloc({required spendingDetailRepository})
      : _spendingDetailRepository = spendingDetailRepository,
        super(SpendingDetailInitialState()) {
    on<GetSpendingDetailEvent>(_getSpendingDetailEventHandler);
  }
  FutureOr<void> _getSpendingDetailEventHandler(event, emit) async {
    emit(SpendingLoadingDetailState());
    try {
      final participants = await _spendingDetailRepository
          .getParticipantsOfSpending(event.spending);
      final userWhoAdded = await event.spending.addedBy.get();
      final addedBy = UserModel.fromMap(userWhoAdded.data());
      emit(SpendingLoadedDetailState(
          spending: event.spending,
          participants: participants,
          addedBy: addedBy));
    } catch (error) {
      emit(SpendingLoadingErrorState());
    }
  }
}
