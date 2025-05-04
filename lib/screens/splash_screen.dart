// lib/screen/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:spendlytic/screens/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // display for 3 seconds
    Navigator.pushReplacement(
      BuildContext as BuildContext,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // or your app's theme color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset('assets/logo.png', width: 150, height: 150),

            const SizedBox(height: 20),

            // App name
            Text(
              'SPENDLYTIC',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.blueAccent, // you can adjust color here
              ),
            ),

            const SizedBox(height: 10),

            // Loading indicator
            const CircularProgressIndicator(
              color: Colors.blueAccent, // match theme color
            ),
          ],
        ),
      ),
    );
  }
}
