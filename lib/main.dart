import 'package:flutter/material.dart';
import 'pages/phone_input_page.dart';
import 'pages/mainHomeScreen.dart';
import 'pages/ProfileSetupPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/',

      routes: {
        '/': (context) => const PhoneInputPage(),
        '/profile': (context) => const ProfileSetupPage(),
        '/home': (context) => MainHomeScreen(),
      },
    );
  }
}