// -----------------------------------------------------------------------
// Filename: screen_splash.dart
// Description: This file contains the splash screen UI which is shown
//              while the application is initializing.

import 'package:flutter/material.dart';

/// A simple, stateless widget that displays the splash screen UI.
/// The decision of *when* to show this screen is handled by the application's
/// router (GoRouter) based on the authentication state. This widget has no
/// logic and is purely for presentation.
class ScreenSplash extends StatelessWidget {
  static const routeName = '/splash';

  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Image.asset(
                "images/logo.png",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "My App",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
