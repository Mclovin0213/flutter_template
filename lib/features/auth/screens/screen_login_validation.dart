// Filename: screen_login_validation.dart
// Description: The initial route for the application. Displays a loading
//              indicator while the router determines the correct screen
//              based on authentication and user profile state.

import 'package:flutter/material.dart';
import 'package:flutter_template/core/widgets/widget_annotated_loading.dart';
import 'package:flutter_template/core/widgets/widget_scrollable_background.dart';

class ScreenLoginValidation extends StatelessWidget {
  static const routeName = '/';

  const ScreenLoginValidation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollableBackground(
        padding: 20,
        child: const WidgetAnnotatedLoading(loadingText: "Initializing..."),
      ),
    );
  }
}
