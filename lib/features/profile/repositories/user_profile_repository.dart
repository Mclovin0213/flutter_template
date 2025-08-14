// -----------------------------------------------------------------------
// Filename: user_profile_repository.dart
// Description: This file contains the repository for user profiles,
//              abstracting data access from Firebase Firestore and Storage.

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/utils/logging/app_logger.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_profile.dart';

part 'user_profile_repository.g.dart';

@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
}

////////////////////////////////////////////////////////////////////////////////////////////
// Class definition for UserProfileRepository
////////////////////////////////////////////////////////////////////////////////////////////

class UserProfileRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  UserProfileRepository(
    this.firebaseAuth,
    this.firestore,
    this.firebaseStorage,
  );

  User? get currentUser => firebaseAuth.currentUser;

  String? get currentUserId => firebaseAuth.currentUser?.uid;

  String _getProfilePicturePath(String uid) =>
      'users/$uid/profile_picture/userProfilePicture.jpg';

  Stream<UserProfile> getUserProfileStream() {
    final user = currentUser;
    if (user == null) {
      return Stream.error(
        Exception("User not authenticated. Cannot stream profile."),
      );
    }
    final String uid = user.uid;

    return firestore
        .collection('user_profiles')
        .doc(uid)
        .snapshots()
        .map((docRef) {
          if (!docRef.exists || docRef.data() == null) {
            throw Exception("User profile does not exist for UID: $uid");
          }
          Map<String, dynamic> data = docRef.data()!;

          data["email"] = user.email;
          data["uid"] = uid;

          return UserProfile.fromJson(data);
        })
        .handleError((e, stackTrace) {
          AppLogger.error(
            "Error streaming user profile from Firestore for UID $uid: $e",
          );
          throw e;
        });
  }

  Future<void> writeUserProfile(
    UserProfile userProfile, {
    bool merge = true,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception("User not authenticated. Cannot write profile.");
    }
    final String uid = user.uid;

    try {
      await firestore
          .collection('user_profiles')
          .doc(uid)
          .set(userProfile.toJson(), SetOptions(merge: merge));
    } catch (e) {
      AppLogger.error(
        "Encountered problem writing user profile to firestore: $e",
      );
      throw Exception("Failed to write user profile: $e");
    }
  }

  Future<ImageProvider?> fetchUserProfileImage(String uid) async {
    try {
      final ref = firebaseStorage.ref().child(_getProfilePicturePath(uid));
      final Uint8List? imageData = await ref.getData();
      if (imageData != null) {
        return MemoryImage(imageData);
      }
    } catch (e) {
      AppLogger.warning(
        "Failed to fetch user profile image for UID $uid (might not exist): $e",
      );
      return null;
    }
    return null;
  }

  Future<void> uploadNewUserProfileImage(File imageFile) async {
    final user = currentUser;
    if (user == null) {
      throw Exception("User not authenticated. Cannot upload profile image.");
    }
    final String uid = user.uid;

    try {
      final String gcsPath = _getProfilePicturePath(uid);
      final Reference ref = firebaseStorage.ref().child(gcsPath);

      SettableMetadata? metadata;
      try {
        final FullMetadata existingMetadata = await ref.getMetadata();
        metadata = SettableMetadata(
          customMetadata: existingMetadata.customMetadata ?? <String, String>{},
        );
      } catch (e) {
        AppLogger.warning(
          "Failed to get existing metadata for profile image: $e. Uploading with new metadata.",
        );
        metadata = SettableMetadata(customMetadata: {});
      }

      await ref.putFile(imageFile, metadata);
    } catch (e) {
      AppLogger.error("Failed to upload new user profile image: $e");
      throw Exception("Failed to upload profile image: $e");
    }
  }

  Future<void> deleteUserProfileImage() async {
    final user = currentUser;
    if (user == null) {
      throw Exception("User not authenticated. Cannot delete profile image.");
    }
    final String uid = user.uid;

    try {
      final String gcsPath = _getProfilePicturePath(uid);
      final Reference ref = firebaseStorage.ref().child(gcsPath);
      await ref.delete();
    } catch (e) {
      AppLogger.warning(
        "Failed to delete user profile image (might not exist): $e",
      );
    }
  }

  Future<void> deleteUserProfileData() async {
    final user = currentUser;
    if (user == null) {
      throw Exception("User not authenticated. Cannot delete profile data.");
    }
    final String userID = user.uid;

    try {
      await firestore.collection('user_profiles').doc(userID).delete();
      AppLogger.print(
        'User profile document deleted successfully for UID: $userID',
      );
    } catch (e) {
      AppLogger.error(
        'Error deleting user profile document for UID $userID: $e',
      );
      throw Exception("Failed to delete user profile data: $e");
    }
  }
}
