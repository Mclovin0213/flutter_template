// Filename: screen_signup.dart
// Description: This file contains the signup screen for creating new user accounts.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/message_display/snackbar.dart';
import 'package:flutter_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_template/features/auth/widgets/widget_password_strength_indicator.dart';
import 'package:go_router/go_router.dart';

class ScreenSignup extends ConsumerStatefulWidget {
  static const routeName = '/signup';
  const ScreenSignup({super.key});

  @override
  ConsumerState<ScreenSignup> createState() => _ScreenSignupState();
}

class _ScreenSignupState extends ConsumerState<ScreenSignup> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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

  Future<void> _trySubmit() async {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_passwordStrength < 0.6) {
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

      await ref.read(authProvider.notifier).signUpWithPassword(email, password);
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
                        setState(() {
                          _passwordStrength = getPasswordStrength(value);
                        });
                      },
                    ),
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _trySubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Create Account"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: const Text("I already have an account"),
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
