import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_repository.dart';
import 'package:tuks_divide/models/payment_model.dart';
import 'package:tuks_divide/models/spending_model.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/models/group_spending_model.dart';

part 'user_activity_event.dart';
part 'user_activity_state.dart';

class UserActivityBloc extends Bloc<UserActivityEvent, UserActivityState> {
  final UserActivityRepository _userActivityRepository;
  int totalActivities = 0;
  UserActivityBloc({required userActivityRepository})
      : _userActivityRepository = userActivityRepository,
        super(UserActivityInitialState()) {
    on<UserActivityLoadEvent>(_loadUserActivityHandler);
  }

  FutureOr<void> _loadUserActivityHandler(event, emit) async {
    try {
      final userActivity = await _userActivityRepository.getUserActivity();
      if (userActivity == null) {
        throw "No se pudo encontrar la actividad del usuario";
      }
      totalActivities = userActivity.myDebts.length +
          userActivity.myPayments.length +
          userActivity.payback.length +
          userActivity.spendingDoneByMe.length +
          userActivity.owings.length;
      emit(UserActivityLoadedState(
          myPayments: userActivity.myPayments,
          myDebts: userActivity.myDebts,
          payback: userActivity.payback,
          otherUsers: userActivity.otherUsers,
          owings: userActivity.owings,
          spendingDoneByMe: userActivity.spendingDoneByMe));
    } catch (error) {
      emit(UserActivityErrorState());
    }
  }
}
