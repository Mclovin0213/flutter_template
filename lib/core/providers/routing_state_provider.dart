import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/utils/logging/app_logger.dart';
import 'package:flutter_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_template/features/profile/models/user_profile.dart';
import 'package:flutter_template/features/profile/providers/user_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing_state_provider.g.dart';

enum RoutingState { unknown, unauthenticated, onboarding, authenticated }

@riverpod
RoutingState routingState(Ref ref) {
  final auth = ref.watch(authProvider);
  AppLogger.debug(
    "RoutingStateProvider: Auth state changed: ${auth.isLoading
        ? 'Loading'
        : auth.hasError
        ? 'Error'
        : 'Data'}",
  );

  return auth.when(
    data: (user) {
      if (user == null) {
        AppLogger.debug("RoutingStateProvider: User is unauthenticated.");
        return RoutingState.unauthenticated;
      }
      AppLogger.debug(
        "RoutingStateProvider: User is authenticated: ${user.uid}",
      );
      final profile = ref.watch(userProfileProvider);
      AppLogger.debug(
        "RoutingStateProvider: UserProfile state changed: ${profile.isLoading
            ? 'Loading'
            : profile.hasError
            ? 'Error'
            : 'Data'}",
      );
      return profile.when(
        data: (profileData) {
          if (profileData.accountCreationStep !=
              AccountCreationStep.ACC_STEP_ONBOARDING_COMPLETE) {
            AppLogger.debug("RoutingStateProvider: User is onboarding.");
            return RoutingState.onboarding;
          }
          AppLogger.debug(
            "RoutingStateProvider: User is authenticated and onboarded.",
          );
          return RoutingState.authenticated;
        },
        loading: () {
          AppLogger.debug(
            "RoutingStateProvider: UserProfile loading, setting state to onboarding.",
          );
          return RoutingState.onboarding;
        },
        error: (_, __) {
          AppLogger.debug(
            "RoutingStateProvider: UserProfile error, setting state to onboarding.",
          );
          return RoutingState.onboarding;
        },
      );
    },
    loading: () {
      AppLogger.debug(
        "RoutingStateProvider: Auth loading, setting state to unknown.",
      );
      return RoutingState.unknown;
    },
    error: (_, __) {
      AppLogger.debug(
        "RoutingStateProvider: Auth error, setting state to unauthenticated.",
      );
      return RoutingState.unauthenticated;
    },
  );
}
