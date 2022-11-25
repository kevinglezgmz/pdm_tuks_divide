import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_repository.dart';

part 'user_activity_event.dart';
part 'user_activity_state.dart';

class UserActivityBloc extends Bloc<UserActivityEvent, UserActivityState> {
  final UserActivityRepository _userActivityRepository;
  UserActivityBloc({required userActivityRepository})
      : _userActivityRepository = userActivityRepository,
        super(UserActivityInitialState()) {
    on<UserActivityEvent>((event, emit) {
      on<UserActivityLoadEvent>(_loadUserActivityHandler);
    });
  }

  FutureOr<void> _loadUserActivityHandler(event, emit) async {
    try {
      final userActivity = await _userActivityRepository.getUserActivity();
      emit(UserActivityLoadedState(activity: userActivity));
    } catch (error) {
      emit(UserActivityErrorState());
    }
  }
}
