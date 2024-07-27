import 'package:celar_app/register/register_page.dart';
import 'package:celar_app/welcome/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: WelcomePage(),
      ),
      initialRoute: "/welcome",
      routes: {
        "/register": (_) => const RegisterPage(),
        "/welcome": (_) => const WelcomePage(),
      },
    );
  }
}
