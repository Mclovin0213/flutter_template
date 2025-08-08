// -----------------------------------------------------------------------
// Filename: screen_splash.dart
// Description: This file checks contains the splash screen which is shown
//              when the app is first opened.

// Flutter external package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// App relative file imports
import '../../providers/auth_provider.dart';
import '../../main.dart';

class ScreenSplash extends ConsumerStatefulWidget {
  // Constructor
  const ScreenSplash({super.key});

  @override
  ConsumerState<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends ConsumerState<ScreenSplash>
    with TickerProviderStateMixin {
  // The "instance variables" managed in this state
  var _isInit = true;
  late ProviderAuth _providerAuth;
  ////////////////////////////////////////////////////////////////
  // Gets the current state of the providers for consumption on
  // this page
  ////////////////////////////////////////////////////////////////
  _init() async {
    // Load providers
    _providerAuth = ref.read(providerAuth);

    // Set splash screen flag
    _providerAuth.isShowingSplash = true;
  }

  ////////////////////////////////////////////////////////////////
  // Runs the following code once upon initialization
  ////////////////////////////////////////////////////////////////
  @override
  void didChangeDependencies() {
    // If first time running this code, update provider settings
    if (_isInit) {
      _init();
    }

    // Now initialized; run super method
    _isInit = false;
    super.didChangeDependencies();
  }

  ////////////////////////////////////////////////////////////////
  // Primary Flutter method overriden which describes the layout
  // and bindings for this widget.
  ////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    // Return the widget for this control
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: Center(
            child: Image.asset(
              "images/logo.png",
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "My App",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
