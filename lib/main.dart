import 'package:flutter/material.dart';
import 'package:tuks_divide/pages/create_group_page/create_group_page.dart';
import 'package:tuks_divide/pages/group_expenses_page/group_expenses_page.dart';
import 'package:tuks_divide/pages/login_page/login_page.dart';
import 'package:tuks_divide/pages/my_groups_page/my_groups_page.dart';
import 'package:tuks_divide/pages/create_group_page/create_group_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color(0xff1CC19F),
            primary: const Color(0xff1CC19F),
            secondary: const Color(0xff1CC19F)),
      ),
      home: CreateGroupPage(),
    );
  }
}
