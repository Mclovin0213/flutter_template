import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_profile.dart';
import '../repositories/user_profile_repository.dart';
import 'user_profile_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Stream<User?> build() {
    return ref
        .watch(userProfileRepositoryProvider)
        .firebaseAuth
        .authStateChanges();
  }

  Future<void> signInWithPassword(String email, String password) async {
    try {
      await ref
          .read(userProfileRepositoryProvider)
          .firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "wrong-password" ||
          e.code == "user-not-found" ||
          e.code == "invalid-email" ||
          e.code == "INVALID_LOGIN_CREDENTIALS" ||
          e.code == "invalid-credential") {
        errorMessage =
            "Email/Password is incorrect - please check your credentials and try again.";
      } else if (e.code == "too-many-requests") {
        errorMessage =
            "Too many failed login attempts - please try again later.";
      } else if (e.code == "timeout") {
        errorMessage =
            "Login attempt took too long - please check internet connection and try again.";
      } else if (e.code == "network-request-failed") {
        errorMessage =
            "A network error occurred - please check internet connection and try again.";
      } else {
        errorMessage =
            "An unknown error occurred during authentication. Please try again.";
      }
      throw Exception(errorMessage);
    } on TimeoutException {
      throw Exception(
        "Login attempt took too long - please check internet connection and try again.",
      );
    } catch (e) {
      throw Exception("An unexpected error occurred during sign-in: $e");
    }
  }

  Future<void> signOut() async {
    await ref.read(userProfileRepositoryProvider).firebaseAuth.signOut();
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
  }

  Future<void> updatePassword(String newPassword, {String? curPassword}) async {
    final userProfileRepo = ref.read(userProfileRepositoryProvider);
    final user = userProfileRepo.firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("No authenticated user to update password.");
    }

    String validationError = _validatePassword(newPassword);
    if (validationError.isNotEmpty) {
      throw Exception(validationError);
    }

    try {
      if (curPassword != null) {
        final authCredential = EmailAuthProvider.credential(
          email: user.email!,
          password: curPassword,
        );
        await user.reauthenticateWithCredential(authCredential);
      }

      await user.updatePassword(newPassword);
      await ref
          .read(userProfileManagerProvider)
          .writeUserProfile(
            (await ref.read(userProfileProvider.future))!.copyWith(
              dateLastPasswordChange: DateTime.now().subtract(
                const Duration(seconds: 5),
              ),
            ),
          );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "wrong-password") {
        errorMessage = "Current password is incorrect.";
      } else if (e.code == "weak-password") {
        errorMessage = e.message ?? "Password is too weak.";
      } else if (e.code == "requires-recent-login") {
        errorMessage = "Please re-login to change your password.";
      } else {
        errorMessage = "An error occurred updating password. Please try again.";
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("An unexpected error occurred updating password: $e");
    }
  }

  Future<void> updateEmail(String newEmail, {String? curPassword}) async {
    final userProfileRepo = ref.read(userProfileRepositoryProvider);
    final user = userProfileRepo.firebaseAuth.currentUser;
    if (user == null) {
      throw Exception("No authenticated user to update email.");
    }

    try {
      if (curPassword != null) {
        final authCredential = EmailAuthProvider.credential(
          email: user.email!,
          password: curPassword,
        );
        await user.reauthenticateWithCredential(authCredential);
      }

      await user.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "wrong-password") {
        errorMessage = "Current password is incorrect.";
      } else if (e.code == "invalid-email" ||
          (e.message?.contains("INVALID_NEW_EMAIL") ?? false)) {
        errorMessage = "$newEmail is not a valid email address.";
      } else if (e.code == "email-already-in-use") {
        errorMessage =
            e.message ?? "$newEmail is already in use by another user.";
      } else {
        errorMessage = "An error occurred updating email. Please try again.";
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("An unexpected error occurred updating email: $e");
    }
  }

  Future<bool> reauthenticateUser(String password) async {
    final user = ref
        .read(userProfileRepositoryProvider)
        .firebaseAuth
        .currentUser;
    if (user == null) return false;

    try {
      final authCredential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(authCredential);
      return true;
    } on FirebaseAuthException {
      return false;
    } catch (e) {
      return false;
    }
  }

  String _validatePassword(String pwCandidate) {
    String passwordResponse = "Password must have: ";
    bool invalidPassword = false;
    int errorCount = 0;

    if (pwCandidate.isEmpty) {
      return 'Enter a password.';
    }

    if (pwCandidate.length < 6) {
      passwordResponse += "6 characters";
      invalidPassword = true;
      errorCount += 1;
    }

    if (!(RegExp(r"(?=.*[a-z])").hasMatch(pwCandidate) ||
        RegExp(r"(?=.*[A-Z])").hasMatch(pwCandidate))) {
      if (invalidPassword) {
        passwordResponse += ", letter";
      } else {
        passwordResponse += "letter";
        invalidPassword = true;
      }
      errorCount += 1;
    }

    if (!(RegExp(r"(?=.*\d)").hasMatch(pwCandidate))) {
      if (invalidPassword) {
        passwordResponse += ", digit";
      } else {
        passwordResponse += "digit";
        invalidPassword = true;
      }
      errorCount += 1;
    }

    if (!(RegExp(r"(?=.*\W)").hasMatch(pwCandidate))) {
      if (invalidPassword) {
        passwordResponse += ", symbol";
      } else {
        passwordResponse += "symbol";
        invalidPassword = true;
      }
      errorCount += 1;
    }

    if (invalidPassword) {
      passwordResponse += ".";
      if (passwordResponse.contains(", ")) {
        int lastIndex = passwordResponse.lastIndexOf(", ");
        String endingPhrase = (errorCount > 2) ? ", and" : " and";
        passwordResponse =
            passwordResponse.substring(0, lastIndex) +
            endingPhrase +
            passwordResponse.substring(lastIndex + 1);
      }
      return passwordResponse;
    }
    return "";
  }

  Future<void> resendVerificationEmail() async {
    final user = state.value;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    await user.sendEmailVerification();
  }

  Future<void> signUpWithPassword(String email, String password) async {
    try {
      final userCredential = await ref
          .read(userProfileRepositoryProvider)
          .firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      const bool ENFORCE_EMAIL_VERIFICATION = true;
      if (ENFORCE_EMAIL_VERIFICATION) {
        await userCredential.user?.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception("An unexpected error occurred during sign-up.");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await ref
          .read(userProfileRepositoryProvider)
          .firebaseAuth
          .sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return;
      }
      throw Exception("An error occurred. Please try again.");
    }
  }
}
