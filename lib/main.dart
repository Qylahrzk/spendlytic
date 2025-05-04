import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendlytic/screens/splash_screen.dart';
import 'package:spendlytic/screens/login_screen.dart';
import 'package:spendlytic/screens/signup_screen.dart'; // <-- Import your signup screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const SpendlyticApp());
}

class SpendlyticApp extends StatelessWidget {
  const SpendlyticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spendlytic',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(), // <-- Add this route!
      },
    );
  }
}
