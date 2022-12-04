import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/models/group_spending_model.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';

part 'user_activity_event.dart';
part 'user_activity_state.dart';

class UserActivityBloc extends Bloc<UserActivityEvent, UserActivityUseState> {
  UserActivityBloc() : super(const UserActivityUseState()) {
    on<UserActivityUpdateStateEvent>(_updateUserActivityStateEventHandler);
  }

  FutureOr<void> _updateUserActivityStateEventHandler(
    UserActivityUpdateStateEvent event,
    Emitter<UserActivityUseState> emit,
  ) {
    emit(state.copyWith(
      paymentsMadeByMe: event.newState.paymentsMadeByMe,
      paymentsMadeToMe: event.newState.paymentsMadeToMe,
      spendingsWhereIDidNotPay: event.newState.spendingsWhereIDidNotPay,
      spendingsWhereIPaid: event.newState.spendingsWhereIPaid,
      spendingsDetails: event.newState.spendingsDetails,
      isLoadingPaymentsByMe: event.newState.isLoadingPaymentsByMe,
      isLoadingPaymentsToMe: event.newState.isLoadingPaymentsToMe,
      isLoadingSpendings: event.newState.isLoadingSpendings,
      userIdToUserMap: event.newState.userIdToUserMap,
    ));
  }
}
