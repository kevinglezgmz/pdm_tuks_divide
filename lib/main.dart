import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/addons/notifications_handler.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_repository.dart';
import 'package:tuks_divide/blocs/create_group_bloc/bloc/create_group_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_repository.dart';
import 'package:tuks_divide/blocs/me_bloc/bloc/me_bloc.dart';
import 'package:tuks_divide/blocs/notifications_bloc/bloc/notifications_bloc.dart';
import 'package:tuks_divide/blocs/payments_bloc/bloc/payments_repository.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_bloc.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_repository.dart';
import 'package:tuks_divide/blocs/spendings_bloc/bloc/spendings_bloc.dart';
import 'package:tuks_divide/blocs/update_user_profile_bloc/bloc/update_user_profile_repository.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_repository.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_repository.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:tuks_divide/pages/home_page/home_page.dart';
import 'package:tuks_divide/pages/login_page/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

const enableNotifications = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (enableNotifications) {
    AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelGroupKey: 'main_channel',
          channelKey: 'new_group_channel',
          channelName: 'Nuevo grupo',
          channelDescription: 'Canal para notificaciones de grupo',
          defaultColor: const Color(0xff1CC19F),
          ledColor: const Color(0xff1CC19F),
        ),
        NotificationChannel(
          channelGroupKey: 'main_channel',
          channelKey: 'new_friend_channel',
          channelName: 'Nuevo amigo',
          channelDescription: 'Canal para notificaciones de amigos',
          defaultColor: const Color(0xff1CC19F),
          ledColor: const Color(0xff1CC19F),
        ),
        NotificationChannel(
          channelGroupKey: 'main_channel',
          channelKey: 'new_spending_channel',
          channelName: 'Nuevo gasto',
          channelDescription: 'Canal para notificaciones de gastos',
          defaultColor: const Color(0xff1CC19F),
          ledColor: const Color(0xff1CC19F),
        ),
        NotificationChannel(
          channelGroupKey: 'main_channel',
          channelKey: 'new_payment_channel',
          channelName: 'Nuevo gasto',
          channelDescription: 'Canal para notificaciones de pagos',
          defaultColor: const Color(0xff1CC19F),
          ledColor: const Color(0xff1CC19F),
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'main_channel',
          channelGroupName: 'Tuks Divide',
        )
      ],
      debug: true,
    );
    //await NotificationController.initializeRemoteNotifications(debug: true);
    //await NotificationController.getFirebaseMessagingToken();
  }
  await Firebase.initializeApp();
  await initializeDateFormatting();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (context) => AuthRepository()),
      RepositoryProvider(create: (context) => GroupsRepository()),
      RepositoryProvider(create: (context) => FriendsRepository()),
      RepositoryProvider(create: (context) => UploadImageRepository()),
      RepositoryProvider(create: (context) => UserActivityRepository()),
      RepositoryProvider(create: (context) => UpdateUserProfileRepository()),
      RepositoryProvider(create: (context) => SpendingDetailRepository()),
      RepositoryProvider(create: (context) => PaymentsRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
          )..add(AuthCheckLoginStatusEvent()),
        ),
        BlocProvider(
          create: (context) => GroupsBloc(
            groupsRepository: context.read<GroupsRepository>(),
          ),
        ),
        BlocProvider(create: (BuildContext context) => CreateGroupBloc()),
        BlocProvider(create: (BuildContext context) => MeBloc()),
        BlocProvider(create: (BuildContext context) => NotificationsBloc()),
        BlocProvider(
          create: (BuildContext context) => SpendingsBloc(
            groupsRepository: context.read<GroupsRepository>(),
          ),
        ),
        BlocProvider(
            create: (BuildContext context) => FriendsBloc(
                friendsRepository: context.read<FriendsRepository>())),
        BlocProvider(
            create: (BuildContext context) => UploadImageBloc(
                uploadImageRepository: context.read<UploadImageRepository>())),
        BlocProvider(create: (BuildContext context) => UserActivityBloc()),
        BlocProvider(
            create: (BuildContext context) => SpendingDetailBloc(
                spendingDetailRepository:
                    context.read<SpendingDetailRepository>())),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (enableNotifications) {
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod,
      );
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          // This is just a basic example. For real apps, you must show some
          // friendly dialog box before call the request method.
          // This is very important to not harm the user experience
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color(0xff1CC19F),
            primary: const Color(0xff1CC19F),
            secondary: const Color(0xff1CC19F)),
      ),
      home: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthNotLoggedInState) {
            return LoginPage();
          } else if (state is AuthLoggingInState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return BlocBuilder<MeBloc, MeUseState>(
            builder: (context, state) {
              if (state.me == null) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return const HomePage();
            },
          );
        },
        listener: (context, state) {
          if (state is AuthNotLoggedInState) {
            BlocProvider.of<MeBloc>(context).add(
              const UpdateMeEvent(
                newMe: null,
              ),
            );
          } else if (state is AuthLoggedInState) {
            BlocProvider.of<MeBloc>(context).add(
              UpdateMeEvent(
                newMe: state.user,
              ),
            );
          }
        },
      ),
    );
  }
}
