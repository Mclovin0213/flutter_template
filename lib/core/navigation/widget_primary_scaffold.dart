import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/features/general/screens/screen_alternate.dart';
import 'package:flutter_template/features/home/screens/screen_home.dart';
import 'package:go_router/go_router.dart';
import 'widget_primary_app_bar.dart';

class WidgetPrimaryScaffold extends ConsumerWidget {
  final Widget child;

  const WidgetPrimaryScaffold({Key? key, required this.child})
    : super(key: key);

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouter.of(context).routerDelegate.state.uri.path;
    if (location.startsWith(ScreenHome.routeName)) {
      return 0;
    }
    if (location.startsWith(ScreenAlternate.routeName)) {
      return 1;
    }
    return 0;
  }

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
    final selectedIndex = _calculateSelectedIndex(context);
    final appBarTitle = _getAppBarTitle(context);

    return Scaffold(
      appBar: WidgetPrimaryAppBar(
        title: Text(appBarTitle),
        actionButtons: null,
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
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
