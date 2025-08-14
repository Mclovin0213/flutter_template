import 'dart:async';

// Flutter external package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/message_display/snackbar.dart';
import 'package:flutter_template/core/widgets/widget_annotated_loading.dart';
import 'package:flutter_template/features/auth/providers/auth_provider.dart';

class ScreenUnverifiedEmail extends ConsumerStatefulWidget {
  const ScreenUnverifiedEmail({super.key});

  static const routeName = '/verify-email';

  @override
  ConsumerState<ScreenUnverifiedEmail> createState() =>
      _ScreenUnverifiedEmailState();
}

class _ScreenUnverifiedEmailState extends ConsumerState<ScreenUnverifiedEmail> {
  Timer? _timer;

  ////////////////////////////////////////////////////////////////////////
  // Runs once when the widget is first created.
  ////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    // Start a timer to periodically check for email verification.
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkEmailVerified();
    });
  }

  ////////////////////////////////////////////////////////////////////////
  // Runs when the widget is removed from the widget tree.
  ////////////////////////////////////////////////////////////////////////
  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks when the screen is closed.
    _timer?.cancel();
    super.dispose();
  }

  ////////////////////////////////////////////////////////////////////////
  // Checks if the current user's email has been verified.
  ////////////////////////////////////////////////////////////////////////
  Future<void> _checkEmailVerified() async {
    // Get the current user from the provider without listening.
    // This is safe to call inside a timer/callback.
    final user = ref.read(authProvider).value;

    // If there's no user, something is wrong, so we stop checking.
    if (user == null) {
      _timer?.cancel();
      return;
    }

    // Reload the user's data from Firebase to get the latest status.
    await user.reload();

    // After reload, if the email is now verified:
    if (user.emailVerified) {
      _timer?.cancel(); // Stop checking.

      // Invalidate the authProvider. This is the key step!
      // It tells Riverpod to re-fetch the user state, ensuring the rest
      // of the app (like the GoRouter redirect) sees the updated
      // `emailVerified` status and can navigate away from this screen.
      ref.invalidate(authProvider);

      // Optionally, show a success message.
      if (mounted) {
        Snackbar.show(
          SnackbarDisplayType.SB_SUCCESS,
          'Email successfully verified!',
          context,
        );
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////
  // Calls the notifier to resend the verification email.
  ////////////////////////////////////////////////////////////////////////
  Future<void> _resendEmail() async {
    try {
      // Call the method on the notifier.
      await ref.read(authProvider.notifier).resendVerificationEmail();
      if (mounted) {
        Snackbar.show(
          SnackbarDisplayType.SB_INFO,
          'Verification email sent.',
          context,
        );
      }
    } catch (e) {
      // Firebase often throws an error if you request too frequently.
      if (mounted) {
        Snackbar.show(
          SnackbarDisplayType.SB_ERROR,
          'An error occurred. Please wait a moment before trying again.',
          context,
        );
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////
  // Calls the notifier to sign the user out.
  ////////////////////////////////////////////////////////////////////////
  void _signOut() {
    ref.read(authProvider.notifier).signOut();
  }

  ////////////////////////////////////////////////////////////////////////
  // Describes the part of the user interface represented by this widget.
  ////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    // Watch the auth provider to get the current user.
    final authUserAsync = ref.watch(authProvider);

    return Scaffold(
      // Use the .when builder for clean handling of async states.
      body: authUserAsync.when(
        data: (user) {
          // If for some reason we end up here with no user, show loading.
          // The GoRouter should prevent this, but it's a good fallback.
          if (user == null) {
            return const WidgetAnnotatedLoading(loadingText: 'Signing out...');
          }
          // The main UI when we have a user object.
          return _buildVerificationUI(context, user.email ?? 'your email');
        },
        loading: () => const WidgetAnnotatedLoading(loadingText: 'Loading...'),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }

  // Helper method to build the main UI, keeping the `build` method clean.
  Widget _buildVerificationUI(BuildContext context, String email) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                "images/logo.png",
                height: MediaQuery.of(context).size.height * .1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Card(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.mark_email_unread_rounded,
                          color: Theme.of(
                            context,
                          ).inputDecorationTheme.iconColor,
                          size: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text(
                        "Check your email",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "An email with an account activation link has been sent to $email.\n\nWrong account?",
                      ),
                      TextSpan(
                        text: ' Sign Out',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = _signOut,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    children: [
                      const TextSpan(text: 'Didn\'t receive an email? '),
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _resendEmail,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
