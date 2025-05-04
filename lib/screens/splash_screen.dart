// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Wait for splash duration

    final userBox = await Hive.openBox('user');
    final email = userBox.get('email', defaultValue: null); // Check if user data exists

    if (email != null) {
      Navigator.pushReplacementNamed(context, '/home'); // Navigate to Home
    } else {
      Navigator.pushReplacementNamed(context, '/login'); // Navigate to Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo image
            Image.asset(
              'assets/images/logo.png', // Path to your logo
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),

            // App name
            const Text(
              'SPENDLYTIC',
              style: TextStyle(
                fontSize: 32,
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Optional loading indicator
            const CircularProgressIndicator(
              color: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
