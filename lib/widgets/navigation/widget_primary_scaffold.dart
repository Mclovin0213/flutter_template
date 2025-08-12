// lib/widgets/navigation/widget_primary_scaffold.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/general/screen_alternate.dart';
import '../../screens/general/screen_home.dart';
import 'widget_primary_app_bar.dart';

/// This is now a simple ConsumerWidget. It doesn't need to be stateful because
/// GoRouter now manages the state of which page is visible.
class WidgetPrimaryScaffold extends ConsumerWidget {
  /// The widget to display in the body of the Scaffold.
  /// GoRouter will pass the screen here based on the current route.
  final Widget child;

  const WidgetPrimaryScaffold({Key? key, required this.child})
    : super(key: key);

  /// Helper method to determine the selected index of the BottomNavigationBar
  /// based on the current route path.
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouter.of(context).routerDelegate.state.uri.path;
    if (location.startsWith(ScreenHome.routeName)) {
      return 0;
    }
    if (location.startsWith(ScreenAlternate.routeName)) {
      return 1;
    }
    // Default to home if the route is not recognized.
    return 0;
  }

  /// Helper method to determine the AppBar title based on the current route.
  String _getAppBarTitle(BuildContext context) {
    final String location = GoRouter.of(context).routerDelegate.state.uri.path;
    if (location.startsWith(ScreenHome.routeName)) {
      return "Home";
    }
    if (location.startsWith(ScreenAlternate.routeName)) {
      return "Alternate";
    }
    return "My App";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We determine the selected index and title directly from the GoRouter state.
    final selectedIndex = _calculateSelectedIndex(context);
    final appBarTitle = _getAppBarTitle(context);

    return Scaffold(
      appBar: WidgetPrimaryAppBar(
        // The title is now determined by the current route.
        title: Text(appBarTitle),
        // Action buttons can also be determined by the route if needed.
        actionButtons: null,
      ),
      // The body is now the child widget passed by the ShellRoute.
      // We no longer need the _getScreenToDisplay method.
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          // When a tab is tapped, we use GoRouter to navigate, not a local StateProvider.
          // This keeps the URL and the UI in sync.
          switch (index) {
            case 0:
              context.go(ScreenHome.routeName);
              break;
            case 1:
              context.go(ScreenAlternate.routeName);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.house)),
          BottomNavigationBarItem(
            label: "Alternate",
            icon: Icon(Icons.business),
          ),
        ],
      ),
    );
  }
}
