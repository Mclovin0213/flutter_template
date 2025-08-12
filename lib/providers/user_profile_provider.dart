// Dart imports
import 'dart:async';
import 'dart:io';

// Flutter external package imports
import 'package:firebase_auth/firebase_auth.dart'; // Import for IdTokenResult
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// App relative file imports
import '../models/user_profile.dart';
import '../repositories/user_profile_repository.dart';
import 'auth_provider.dart'; // Import auth_provider for dependency

part 'user_profile_provider.g.dart';

// --- User Profile Stream Provider ---

/// Provides a stream of the current authenticated user's [UserProfile] object.
/// It watches the `authProvider` to react to user login/logout events.
@riverpod
Stream<UserProfile> userProfile(Ref ref) {
  final authUserAsync = ref.watch(
    authProvider,
  ); // Watch the authentication state

  // If there's no authenticated user, return an error stream
  // This will cause userProfileProvider.valueOrNull to be null in widgets,
  // indicating no profile is available.
  if (authUserAsync.valueOrNull == null) {
    return Stream.error(
      Exception("User not logged in or profile not available."),
    );
  }

  // Fetch the profile from the repository using the current user's UID.
  // Use `getUserProfileStream()` as per your repository's method name.
  return ref.watch(userProfileRepositoryProvider).getUserProfileStream();
}

// --- User Profile Image Stream Provider ---

/// Provides the profile image for the current authenticated user as a [Future<ImageProvider?>].
/// It depends on the `userProfileProvider` to get the user's UID.
@riverpod
Future<ImageProvider?> userProfileImage(Ref ref) async {
  final userProfileAsync = ref.watch(userProfileProvider);

  // If user profile is not loaded or there's an error, no image to fetch
  if (userProfileAsync.valueOrNull == null) {
    return null;
  }

  final user = userProfileAsync.value!; // Get the actual UserProfile object
  // Call `fetchUserProfileImage` on the repository, passing the UID.
  return ref
      .watch(userProfileRepositoryProvider)
      .fetchUserProfileImage(user.uid);
}

// --- User Profile Management Provider ---

/// Provides methods for performing actions related to the user profile,
/// such as writing data, uploading/removing images, and deleting account data.
/// It doesn't hold direct state but facilitates operations via the repository.
@riverpod
UserProfileManager userProfileManager(Ref ref) {
  return UserProfileManager(ref);
}

class UserProfileManager {
  final Ref _ref;

  UserProfileManager(this._ref);

  UserProfileRepository get _userProfileRepository =>
      _ref.read(userProfileRepositoryProvider);

  // Note: FirebaseAuth is accessed via userProfileRepository, not directly here.
  // If direct FirebaseAuth access is needed for profile management, it should be passed
  // or accessed via the repository. For now, it's accessed via the repository.

  /// Writes the provided [UserProfile] to the database.
  /// After writing, it invalidates `userProfileProvider` to trigger a refetch.
  Future<void> writeUserProfile(
    UserProfile userProfile, {
    bool merge = true,
  }) async {
    await _userProfileRepository.writeUserProfile(userProfile, merge: merge);
    _ref.invalidate(
      userProfileProvider,
    ); // Force a refresh of the user profile stream
  }

  /// Uploads a new user profile image.
  /// Requires the current user to be authenticated.
  /// After upload, it invalidates `userProfileImageProvider` to show the new image.
  Future<void> uploadNewUserProfileImage(File imageFile) async {
    await _userProfileRepository.uploadNewUserProfileImage(imageFile);
    _ref.invalidate(
      userProfileImageProvider,
    ); // Force a refresh of the profile image
  }

  /// Removes the current user's profile image.
  /// Requires the current user to be authenticated.
  /// After removal, it invalidates `userProfileImageProvider` to clear the image.
  Future<void> removeUserProfileImage() async {
    await _userProfileRepository.deleteUserProfileImage();
    _ref.invalidate(
      userProfileImageProvider,
    ); // Force a refresh of the profile image (will become null)
  }

  /// Deletes all account data associated with the current user in Firestore and Storage.
  /// Note: This method does NOT delete the Firebase Auth user itself. That usually happens
  /// as a final step from the UI layer using `FirebaseAuth.instance.currentUser.delete()`.
  Future<void> deleteAccountData() async {
    await _userProfileRepository.deleteUserProfileData();
    // Invalidate the profile provider as the data is now gone.
    _ref.invalidate(userProfileProvider);
    _ref.invalidate(userProfileImageProvider);
  }

  /// Checks if the user's password has been changed on another device since this one was authenticated.
  /// If so, it triggers a sign-out. This is typically called on app startup or before sensitive operations.
  Future<void> ensurePasswordUpToDate() async {
    final user = _userProfileRepository
        .firebaseAuth
        .currentUser; // Use firebaseAuth from the repository
    if (user == null) return; // Not authenticated, nothing to check

    final userProfileAsync = _ref.read(userProfileProvider);
    final userProfile =
        userProfileAsync.valueOrNull; // Handle loading/error states for profile

    if (userProfile == null) return; // Profile not loaded yet

    try {
      IdTokenResult idTokenResult = await user.getIdTokenResult();
      DateTime? lastAuthTime = idTokenResult.authTime;
      DateTime? lastPwChangeTime = userProfile.dateLastPasswordChange;

      if (lastAuthTime == null || lastPwChangeTime == null) return;

      if (lastPwChangeTime.isAfter(lastAuthTime)) {
        // Password was changed elsewhere; sign out this device.
        await _ref.read(authProvider.notifier).signOut();
        // The UI should react to the signOut and navigate to login.
      }
    } catch (e) {
      // Log any errors during this check, but don't prevent app from running
      // AppLogger.error("Error checking password update status: $e"); // If you want to use AppLogger here
    }
  }
}
