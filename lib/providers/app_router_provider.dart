import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../screens/general/screen_alternate.dart';
import '../screens/general/screen_home.dart';
import '../widgets/navigation/widget_primary_scaffold.dart';
import '../screens/auth/screen_login_validation.dart';
import '../screens/settings/screen_profile_edit.dart';
import 'auth_provider.dart'; // Assuming auth_provider is needed for redirection logic

part 'app_router_provider.g.dart'; // Generated file for Riverpod

// A new provider for our router
@riverpod
GoRouter goRouter(Ref ref) {
  // Watch the auth provider's underlying stream for changes
  final authStream = ref.watch(authProvider.notifier).build();

  return GoRouter(
    initialLocation:
        ScreenLoginValidation.routeName, // Start at login validation
    // The refreshListenable is the key to automatic redirection
    refreshListenable: GoRouterRefreshStream(authStream),
    routes: [
      GoRoute(
        path: ScreenLoginValidation.routeName,
        builder: (context, state) => const ScreenLoginValidation(),
      ),
      GoRoute(
        path: ScreenProfileEdit.routeName,
        builder: (context, state) => const ScreenProfileEdit(),
      ),
      GoRoute(
        path: WidgetPrimaryScaffold.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            const WidgetPrimaryScaffold(),
      ),
      GoRoute(
        path: ScreenHome.routeName,
        builder: (BuildContext context, GoRouterState state) => ScreenHome(),
      ),
      GoRoute(
        path: ScreenAlternate.routeName,
        builder: (BuildContext context, GoRouterState state) =>
            ScreenAlternate(),
      ),
      // ... other routes
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Get the current authentication state from the provider
      final authState = ref.watch(authProvider);
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthenticating = authState.isLoading;

      final onLoginPage =
          state.matchedLocation == ScreenLoginValidation.routeName;

      // If authenticating, don't redirect anywhere yet
      if (isAuthenticating) return null;

      // If on login page but already logged in, go to home
      if (onLoginPage && isAuthenticated) {
        return ScreenHome.routeName;
      }

      // If not on login page and not logged in, go to login
      if (!onLoginPage && !isAuthenticated) {
        return ScreenLoginValidation.routeName;
      }

      // No redirect needed
      return null;
    },
  );
}

// Helper class for GoRouter refreshListenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
