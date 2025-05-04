import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import your screens
import 'package:spendlytic/screens/splash_screen.dart';
import 'package:spendlytic/screens/login_screen.dart';
import 'package:spendlytic/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (important!)
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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),

      // Initial screen
      home: const SplashScreen(),

      // Define named routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen()
      },
    );
  }
}
