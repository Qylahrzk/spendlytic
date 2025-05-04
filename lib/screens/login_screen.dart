// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  late Box userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('user');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  void _login() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text;

      if (kDebugMode) {
        print("Login attempt: $email");
        print("Hive Data: ${userBox.toMap()}");
      }

      if (userBox.containsKey(email)) {
        final userData = userBox.get(email);
        if (userData is Map && userData.containsKey('password')) {
          final storedPassword = userData['password'];

          if (storedPassword == password) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            _showErrorDialog('Incorrect password.');
          }
        } else {
          _showErrorDialog('User data corrupted. Please sign up again.');
        }
      } else {
        _showErrorDialog('Account does not exist. Please sign up.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB39DDB), Color(0xFFD1C4E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Hero(
                  tag: 'appLogo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                    ),
                  ),
                const SizedBox(height: 50),

                // Email
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24),

                // Log In Button (dark purple)
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white, // white text
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Log In', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),

                // Sign Up
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    "Don't have account? Sign Up",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
