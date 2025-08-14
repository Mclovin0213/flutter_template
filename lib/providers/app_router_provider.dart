import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/screens/auth/screen_auth.dart';
import 'package:flutter_template/screens/auth/screen_login.dart';
import 'package:flutter_template/screens/auth/screen_signup.dart';
import 'package:flutter_template/screens/auth/screen_profile_setup.dart';
import 'package:flutter_template/screens/auth/screen_unverified_email.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/screens/auth/screen_splash.dart';
import 'package:flutter_template/providers/routing_state_provider.dart';

import '../screens/general/screen_alternate.dart';
import '../screens/general/screen_home.dart';
import '../widgets/navigation/widget_primary_scaffold.dart';
import 'auth_provider.dart';

part 'app_router_provider.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final routingState = ref.watch(routingStateProvider);

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authProvider.notifier).build(),
    ),
    initialLocation: ScreenSplash.routeName,
    routes: [
      // --- AUTHENTICATION FLOW ROUTES (FLAT) ---
      GoRoute(
        path: ScreenSplash.routeName,
        builder: (context, state) => const ScreenSplash(),
      ),
      GoRoute(
        path: ScreenAuth.routeName,
        builder: (context, state) => const ScreenAuth(),
      ),
      GoRoute(
        path: ScreenLogin.routeName,
        builder: (context, state) => const ScreenLogin(),
      ),
      GoRoute(
        path: ScreenSignup.routeName,
        builder: (context, state) => const ScreenSignup(),
      ),
      GoRoute(
        path: ScreenUnverifiedEmail.routeName,
        builder: (context, state) => const ScreenUnverifiedEmail(),
      ),
      GoRoute(
        path: ScreenProfileSetup.routeName,
        builder: (context, state) => const ScreenProfileSetup(isAuth: true),
      ),

      // --- AUTHENTICATED APP ROUTES (NESTED IN A SHELL) ---
      ShellRoute(
        builder: (context, state, child) {
          return WidgetPrimaryScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: ScreenHome.routeName,
            builder: (BuildContext context, GoRouterState state) =>
                ScreenHome(),
          ),
          GoRoute(
            path: ScreenAlternate.routeName,
            builder: (BuildContext context, GoRouterState state) =>
                ScreenAlternate(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final location = state.uri.path;

      switch (routingState) {
        case RoutingState.unknown:
          return ScreenSplash.routeName;

        case RoutingState.unauthenticated:
          final authFlowRoutes = [
            ScreenAuth.routeName,
            ScreenLogin.routeName,
            ScreenSignup.routeName,
          ];

          if (!authFlowRoutes.contains(location)) {
            return ScreenAuth.routeName;
          }
          return null;

        case RoutingState.onboarding:
          return ScreenProfileSetup.routeName;

        case RoutingState.authenticated:
          final loginFlowRoutes = [
            ScreenAuth.routeName,
            ScreenLogin.routeName,
            ScreenSignup.routeName,
            ScreenProfileSetup.routeName,
            ScreenSplash.routeName,
            ScreenUnverifiedEmail.routeName,
          ];
          if (loginFlowRoutes.contains(location)) {
            return ScreenHome.routeName;
          }
          return null;
      }
    },
  );
}

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
