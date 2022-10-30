import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_bloc.dart';
import 'package:tuks_divide/blocs/auth_bloc/bloc/auth_repository.dart';
import 'package:tuks_divide/pages/home_page/home_page.dart';
import 'package:tuks_divide/pages/login_page/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(
        create: (context) => AuthRepository(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: context.read<AuthRepository>())
                ..add(AuthCheckLoginStatusEvent()),
        ),
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
      home: BlocBuilder<AuthBloc, AuthState>(
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
