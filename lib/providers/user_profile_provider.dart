import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_profile.dart';
import '../repositories/user_profile_repository.dart';
import 'auth_provider.dart';

part 'user_profile_provider.g.dart';

@riverpod
Stream<UserProfile> userProfile(Ref ref) {
  final authUserAsync = ref.watch(authProvider);

  if (authUserAsync.valueOrNull == null) {
    return Stream.error(
      Exception("User not logged in or profile not available."),
    );
  }

  return ref.watch(userProfileRepositoryProvider).getUserProfileStream();
}

@riverpod
Future<ImageProvider?> userProfileImage(Ref ref) async {
  final userProfileAsync = ref.watch(userProfileProvider);

  if (userProfileAsync.valueOrNull == null) {
    return null;
  }

  final user = userProfileAsync.value!;

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
    _ref.invalidate(userProfileProvider);
  }

  /// Uploads a new user profile image.
  /// Requires the current user to be authenticated.
  /// After upload, it invalidates `userProfileImageProvider` to show the new image.
  Future<void> uploadNewUserProfileImage(File imageFile) async {
    await _userProfileRepository.uploadNewUserProfileImage(imageFile);
    _ref.invalidate(userProfileImageProvider);
  }

  /// Removes the current user's profile image.
  /// Requires the current user to be authenticated.
  /// After removal, it invalidates `userProfileImageProvider` to clear the image.
  Future<void> removeUserProfileImage() async {
    await _userProfileRepository.deleteUserProfileImage();
    _ref.invalidate(userProfileImageProvider);
  }

  /// Deletes all account data associated with the current user in Firestore and Storage.
  /// Note: This method does NOT delete the Firebase Auth user itself. That usually happens
  /// as a final step from the UI layer using `FirebaseAuth.instance.currentUser.delete()`.
  Future<void> deleteAccountData() async {
    await _userProfileRepository.deleteUserProfileData();
    _ref.invalidate(userProfileProvider);
    _ref.invalidate(userProfileImageProvider);
  }

  /// Checks if the user's password has been changed on another device since this one was authenticated.
  /// If so, it triggers a sign-out. This is typically called on app startup or before sensitive operations.
  Future<void> ensurePasswordUpToDate() async {
    final user = _userProfileRepository.firebaseAuth.currentUser;
    if (user == null) return;

    final userProfileAsync = _ref.read(userProfileProvider);
    final userProfile = userProfileAsync.valueOrNull;

    if (userProfile == null) return;

    try {
      IdTokenResult idTokenResult = await user.getIdTokenResult();
      DateTime? lastAuthTime = idTokenResult.authTime;
      DateTime? lastPwChangeTime = userProfile.dateLastPasswordChange;

      if (lastAuthTime == null || lastPwChangeTime == null) return;

      if (lastPwChangeTime.isAfter(lastAuthTime)) {
        await _ref.read(authProvider.notifier).signOut();
      }
    } catch (e) {}
  }
}
