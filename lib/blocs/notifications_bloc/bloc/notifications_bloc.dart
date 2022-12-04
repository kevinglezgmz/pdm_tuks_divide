import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsUseState> {
  NotificationsBloc() : super(const NotificationsUseState()) {
    on<UpdateNotificationsEvent>(_updateNotificationsEventHandler);
  }

  FutureOr<void> _updateNotificationsEventHandler(
      UpdateNotificationsEvent event, Emitter<NotificationsUseState> emit) {
    emit(event.newState);
  }
}
