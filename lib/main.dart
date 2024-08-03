import 'package:celar_app/generate_register/generate_register_page.dart';
import 'package:celar_app/home/home_page.dart';
import 'package:celar_app/register/register_page.dart';
import 'package:celar_app/registration/registration_page.dart';
import 'package:celar_app/report/report_page.dart';
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
        "/home": (_) => const HomePage(),
        "/registration-list": (_) => const RegistrationPage(),
        "/report": (_) => const ReportPage(),
        "/generate-register": (_) => const GenerateRegisterPage(),
      },
    );
  }
}
