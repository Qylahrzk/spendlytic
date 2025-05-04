// SPLASH SCREEN (with scale animation)
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
    await Future.delayed(const Duration(seconds: 3)); // Slightly longer to enjoy animation

    final userBox = await Hive.openBox('user');
    final email = userBox.get('email', defaultValue: null);

    if (email != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 2.0, end: 1.0),
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Hero(          // <-- Hero tag here (IMPORTANT)
                tag: 'appLogo',
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
