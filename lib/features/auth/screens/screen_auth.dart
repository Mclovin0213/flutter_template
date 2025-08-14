// Filename: screen_auth.dart
// Description: This file contains the screen for authenticating users (login, account creation).

// Flutter external package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// App relative file imports
import 'screen_login.dart';
import 'screen_signup.dart';

class ScreenAuth extends ConsumerStatefulWidget {
  static const routeName = '/auth';
  const ScreenAuth({super.key});

  @override
  ConsumerState<ScreenAuth> createState() => _ScreenAuthState();
}

class _ScreenAuthState extends ConsumerState<ScreenAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/logo.png", height: 150),
            const SizedBox(height: 8),
            const Text(
              "My App",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(ScreenLogin.routeName),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 48,
                ),
              ),
              child: const Text("Sign In"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(ScreenSignup.routeName),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 48,
                ),
              ),
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
