import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_repository.dart';
<<<<<<< HEAD
=======
import 'package:tuks_divide/blocs/create_group_bloc/bloc/create_group_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_bloc.dart';
import 'package:tuks_divide/blocs/friends_bloc/bloc/friends_repository.dart';
>>>>>>> 7c65b6436cbb56d808c8a2425feba7491d8a689a
import 'package:tuks_divide/blocs/upload_image_bloc/bloc/upload_image_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_bloc.dart';
import 'package:tuks_divide/blocs/groups_bloc/bloc/groups_repository.dart';
import 'package:tuks_divide/models/user_model.dart';
import 'package:tuks_divide/pages/home_page/home_page.dart';
import 'package:tuks_divide/pages/login_page/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (context) => AuthRepository()),
      RepositoryProvider(create: (context) => GroupsRepository()),
      RepositoryProvider(create: (context) => FriendsRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
          )..add(AuthCheckLoginStatusEvent()),
        ),
        BlocProvider(create: (BuildContext context) => UploadImageBloc()),
        BlocProvider(create: (BuildContext context) => CreateGroupBloc()),
        BlocProvider(
            create: (BuildContext context) => FriendsBloc(
                friendsRepository: context.read<FriendsRepository>())),
        BlocProvider(
          create: (context) =>
              GroupsBloc(groupsRepository: context.read<GroupsRepository>()),
        )
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
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedInState) {
            final UserModel? me = BlocProvider.of<AuthBloc>(context).me;
            if (me != null) {
              BlocProvider.of<GroupsBloc>(context).add(LoadUserGroupsEvent());
              BlocProvider.of<FriendsBloc>(context).add(LoadUserFriendsEvent());
            }
          }
        },
        builder: (context, state) {
          if (state is AuthNotLoggedInState) {
            return LoginPage();
          } else if (state is AuthLoggingInState) {
            // To Do: Implement Loading Over The Home Screen
            return LoginPage();
          }
          return const HomePage();
        },
      ),
    );
  }
}
