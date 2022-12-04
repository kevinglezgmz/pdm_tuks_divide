part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class UpdateNotificationsEvent extends NotificationsEvent {
  final NotificationsUseState newState;

  const UpdateNotificationsEvent({required this.newState});

  @override
  List<Object> get props => [newState];
}
