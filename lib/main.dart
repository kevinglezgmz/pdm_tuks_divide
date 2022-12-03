import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_repository.dart';
import 'package:tuks_divide/blocs/create_group_bloc/bloc/create_group_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_repository.dart';
import 'package:tuks_divide/blocs/payment_detail_bloc/bloc/payment_detail_bloc.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_bloc.dart';
import 'package:tuks_divide/blocs/spending_detail_bloc/bloc/spending_detail_repository.dart';
import 'package:tuks_divide/blocs/spendings_bloc/bloc/spendings_bloc.dart';
import 'package:tuks_divide/blocs/update_user_profile_bloc/bloc/update_user_profile_bloc.dart';
import 'package:tuks_divide/blocs/update_user_profile_bloc/bloc/update_user_profile_repository.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_repository.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_bloc.dart';
import 'package:tuks_divide/blocs/user_activity_bloc/bloc/user_activity_repository.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/home_page/home_page.dart';
import 'package:tuks_divide/pages/login_page/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (context) => AuthRepository()),
      RepositoryProvider(create: (context) => GroupsRepository()),
      RepositoryProvider(create: (context) => FriendsRepository()),
      RepositoryProvider(create: (context) => UploadImageRepository()),
      RepositoryProvider(create: (context) => UserActivityRepository()),
      RepositoryProvider(create: (context) => UpdateUserProfileRepository()),
      RepositoryProvider(create: (context) => SpendingDetailRepository()),
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
        BlocProvider(
            create: (BuildContext context) => UserActivityBloc(
                userActivityRepository:
                    context.read<UserActivityRepository>())),
        BlocProvider(
            create: (BuildContext context) => UpdateUserProfileBloc(
                updateUserProfileRepository:
                    context.read<UpdateUserProfileRepository>())),
        BlocProvider(
            create: (BuildContext context) => SpendingDetailBloc(
                spendingDetailRepository:
                    context.read<SpendingDetailRepository>())),
        BlocProvider(create: (BuildContext context) => PaymentDetailBloc())
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthNotLoggedInState) {
            return LoginPage();
          } else if (state is AuthLoggingInState) {
            // To Do: Implement Loading Over The Home Screen
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return const HomePage();
        },
      ),
    );
  }
}
