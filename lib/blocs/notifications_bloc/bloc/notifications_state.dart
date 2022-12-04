part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsUseState extends NotificationsState {
  final bool groupNotificationsEnabled;
  final bool spendingNotificationsEnabled;
  final bool paymentNotificationsEnabled;
  final bool friendNotificationsEnabled;

  const NotificationsUseState({
    this.groupNotificationsEnabled = true,
    this.spendingNotificationsEnabled = true,
    this.paymentNotificationsEnabled = true,
    this.friendNotificationsEnabled = true,
  });

  NotificationsUseState copyWith({
    bool? groupNotificationsEnabled,
    bool? spendingNotificationsEnabled,
    bool? paymentNotificationsEnabled,
    bool? friendNotificationsEnabled,
  }) {
    return NotificationsUseState(
      groupNotificationsEnabled:
          groupNotificationsEnabled ?? this.groupNotificationsEnabled,
      spendingNotificationsEnabled:
          spendingNotificationsEnabled ?? this.spendingNotificationsEnabled,
      paymentNotificationsEnabled:
          paymentNotificationsEnabled ?? this.paymentNotificationsEnabled,
      friendNotificationsEnabled:
          friendNotificationsEnabled ?? this.friendNotificationsEnabled,
    );
  }

  @override
  List<Object> get props => [
        groupNotificationsEnabled,
        spendingNotificationsEnabled,
        paymentNotificationsEnabled,
        friendNotificationsEnabled,
      ];
}
