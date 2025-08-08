import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/models/user_profile.dart';
import 'package:flutter_template/screens/auth/screen_auth.dart';
import 'package:flutter_template/screens/auth/screen_profile_setup.dart';
import 'package:flutter_template/screens/auth/screen_unverified_email.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../screens/general/screen_alternate.dart';
import '../screens/general/screen_home.dart';
import '../widgets/navigation/widget_primary_scaffold.dart';
import '../screens/auth/screen_login_validation.dart';
import '../screens/settings/screen_profile_edit.dart';
import 'auth_provider.dart';

part 'app_router_provider.g.dart'; // Generated file for Riverpod

const bool ENFORCE_EMAIL_VERIFICATION = false;

// A new provider for our router
@riverpod
GoRouter goRouter(Ref ref) {
  // Watch the auth provider's underlying stream for changes
  final authStream = ref.watch(authProvider.notifier).build();

  return GoRouter(
    initialLocation: ScreenLoginValidation.routeName,
    // The refreshListenable is the key to automatic redirection
    refreshListenable: GoRouterRefreshStream(authStream),
    routes: [
      GoRoute(
        path: ScreenLoginValidation.routeName,
        builder: (context, state) => const ScreenLoginValidation(),
      ),
      GoRoute(
        path: ScreenAuth.routeName, // e.g., "/login"
        builder: (context, state) => const ScreenAuth(),
      ),
      GoRoute(
        path: ScreenUnverifiedEmail.routeName, // e.g., "/verify-email"
        builder: (context, state) => const ScreenUnverifiedEmail(),
      ),
      GoRoute(
        path: ScreenProfileEdit.routeName,
        builder: (context, state) => const ScreenProfileEdit(),
      ),
      GoRoute(
        path: ScreenProfileSetup.routeName, // e.g., "/setup-profile"
        builder: (context, state) => const ScreenProfileSetup(isAuth: true),
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
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      final authAsync = ref.read(authProvider);
      final location = state.uri.path;

      // 1. If auth state is loading, don't redirect.
      if (authAsync.isLoading) {
        return null;
      }

      final user = authAsync.valueOrNull;

      // 2. If the user is not logged in, force them to the login screen.
      if (user == null) {
        return location == ScreenAuth.routeName ? null : ScreenAuth.routeName;
      }

      // --- From here, we know the user is authenticated ---

      // 3. Check for email verification.
      if (ENFORCE_EMAIL_VERIFICATION && !user.emailVerified) {
        return location == ScreenUnverifiedEmail.routeName
            ? null
            : ScreenUnverifiedEmail.routeName;
      }

      // 4. Check for a valid and complete user profile.
      try {
        // Await the profile to see if it exists and is complete.
        final userProfile = await ref.read(userProfileProvider.future);

        // If it exists, check if onboarding is complete.
        if (userProfile.accountCreationStep ==
            AccountCreationStep.ACC_STEP_ONBOARDING_PROFILE_CONTACT_INFO) {
          // It's not complete, so force user to the setup screen.
          return location == ScreenProfileSetup.routeName
              ? null
              : ScreenProfileSetup.routeName;
        }
      } catch (error) {
        // THIS IS THE KEY CHANGE: The `catch` block now handles the case where the
        // user has just signed up and has NO profile document yet.
        // We must direct them to the setup screen to create it.
        return location == ScreenProfileSetup.routeName
            ? null
            : ScreenProfileSetup.routeName;
      }

      // 5. If user is fully set up, but on a "login flow" page, send to home.
      final loginFlowRoutes = [
        ScreenLoginValidation.routeName,
        ScreenAuth.routeName,
        ScreenUnverifiedEmail.routeName,
        ScreenProfileSetup.routeName,
      ];
      if (loginFlowRoutes.contains(location)) {
        return WidgetPrimaryScaffold.routeName; // Your main app screen route
      }

      // 6. Otherwise, no redirect is needed.
      return null;
    },
  );
}

// Helper class for GoRouter refreshListenable (no changes needed here)
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
