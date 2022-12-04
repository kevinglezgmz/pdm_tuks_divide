import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuks_divide/blocs/notifications_bloc/bloc/notifications_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsUseState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Notificaciones",
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                child: ListTile(
                  title: const Text("Notificaciones de nuevos grupos"),
                  trailing: Switch(
                    value: state.groupNotificationsEnabled,
                    onChanged: (value) {
                      BlocProvider.of<NotificationsBloc>(context).add(
                        UpdateNotificationsEvent(
                          newState: state.copyWith(
                            groupNotificationsEnabled: value,
                          ),
                        ),
                      );
                    },
                  ),
                  leading: const Icon(
                    Icons.group,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Notificaciones de nuevos amigos"),
                  trailing: Switch(
                    value: state.friendNotificationsEnabled,
                    onChanged: (value) {
                      BlocProvider.of<NotificationsBloc>(context).add(
                        UpdateNotificationsEvent(
                          newState: state.copyWith(
                            friendNotificationsEnabled: value,
                          ),
                        ),
                      );
                    },
                  ),
                  leading: const Icon(
                    Icons.person,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Notificaciones de nuevos gastos"),
                  trailing: Switch(
                    value: state.spendingNotificationsEnabled,
                    onChanged: (value) {
                      BlocProvider.of<NotificationsBloc>(context).add(
                        UpdateNotificationsEvent(
                          newState: state.copyWith(
                            spendingNotificationsEnabled: value,
                          ),
                        ),
                      );
                    },
                  ),
                  leading: const Icon(
                    Icons.article_outlined,
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Notificaciones de nuevos pagos"),
                  trailing: Switch(
                    value: state.paymentNotificationsEnabled,
                    onChanged: (value) {
                      BlocProvider.of<NotificationsBloc>(context).add(
                        UpdateNotificationsEvent(
                          newState: state.copyWith(
                            paymentNotificationsEnabled: value,
                          ),
                        ),
                      );
                    },
                  ),
                  leading: const Icon(
                    Icons.payments_outlined,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
