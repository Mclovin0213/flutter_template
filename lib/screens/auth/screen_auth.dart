// Filename: screen_auth.dart
// Description: This file contains the screen for authenticating users (login, account creation).

// Flutter external package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// App relative file imports
import '../../widgets/auth/widget_password_strength_indicator.dart';
import '../../providers/auth_provider.dart';
import '../../util/message_display/snackbar.dart';

class ScreenAuth extends ConsumerStatefulWidget {
  static const routeName = '/auth';
  const ScreenAuth({super.key});

  @override
  ConsumerState<ScreenAuth> createState() => _ScreenAuthState();
}

class _ScreenAuthState extends ConsumerState<ScreenAuth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Local UI State
  bool _signInMode = true;
  bool _passwordVisible = false;
  bool _isLoading = false;
  double _passwordStrength = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Tries to submit the form for either sign-in or sign-up.
  Future<void> _trySubmit() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    // Additional check for password strength in sign-up mode
    if (!_signInMode && _passwordStrength < 0.6) {
      Snackbar.show(
        SnackbarDisplayType.SB_ERROR,
        "Please improve your password strength.",
        context,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (_signInMode) {
        await ref
            .read(authProvider.notifier)
            .signInWithPassword(email, password);
      } else {
        await ref
            .read(authProvider.notifier)
            .signUpWithPassword(email, password);
      }
      // On success, GoRouter will automatically navigate away. No need for any navigation code here.
    } catch (e) {
      if (mounted) {
        Snackbar.show(SnackbarDisplayType.SB_ERROR, e.toString(), context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Shows a dialog to get the user's email for a password reset.
  void _showPasswordResetDialog() {
    final resetEmailController = TextEditingController(
      text: _emailController.text,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset Password"),
        content: TextField(
          controller: resetEmailController,
          autofillHints: const [AutofillHints.email],
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Email Address"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
              _sendPasswordReset(resetEmailController.text.trim());
            },
            child: const Text("Send Reset Email"),
          ),
        ],
      ),
    );
  }

  /// Calls the provider to send a password reset email.
  Future<void> _sendPasswordReset(String email) async {
    if (email.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).sendPasswordResetEmail(email);
      if (mounted) {
        Snackbar.show(
          SnackbarDisplayType.SB_INFO,
          "If an account exists, a password reset email has been sent.",
          context,
        );
      }
    } catch (e) {
      if (mounted) {
        Snackbar.show(SnackbarDisplayType.SB_ERROR, e.toString(), context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("images/logo.png", height: 150),
                    const SizedBox(height: 8),
                    const Text(
                      "My App",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      autofillHints: const [AutofillHints.username],
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                          (value?.isEmpty ?? true) || !value!.contains('@')
                          ? 'Please enter a valid email.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      autofillHints: const [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(
                            () => _passwordVisible = !_passwordVisible,
                          ),
                        ),
                      ),
                      validator: (value) => (value?.isEmpty ?? true)
                          ? 'Please enter a password.'
                          : null,
                      onChanged: (value) {
                        if (!_signInMode) {
                          setState(() {
                            _passwordStrength = getPasswordStrength(value);
                          });
                        }
                      },
                    ),
                    if (!_signInMode) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_passwordVisible,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                        validator: (value) => _passwordController.text != value
                            ? 'Passwords do not match.'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      if (_passwordController.text.isNotEmpty)
                        WidgetPasswordStrengthIndicator(
                          passwordStrength: _passwordStrength,
                          passwordText: getPasswordStrengthText(
                            _passwordStrength,
                          ),
                          passwordColor: getPasswordStrengthColor(
                            _passwordStrength,
                          ),
                        ),
                    ],
                    if (_signInMode)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _showPasswordResetDialog,
                          child: const Text("Forgot Password?"),
                        ),
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _trySubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_signInMode ? "Sign In" : "Create Account"),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _signInMode = !_signInMode),
                      child: Text(
                        _signInMode
                            ? "Create an account"
                            : "I already have an account",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
