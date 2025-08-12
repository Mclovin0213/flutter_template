// Dart imports
import 'dart:io';

// Flutter external package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/providers/user_profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// App relative file imports
import '../../widgets/general/widget_profile_avatar.dart';
import '../../util/message_display/snackbar.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_profile.dart';

class ScreenProfileSetup extends ConsumerStatefulWidget {
  static const routeName = '/profileSetup';

  final bool isAuth;

  const ScreenProfileSetup({super.key, this.isAuth = false});

  @override
  ConsumerState<ScreenProfileSetup> createState() => _ScreenProfileSetupState();
}

class _ScreenProfileSetupState extends ConsumerState<ScreenProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  // Local UI state
  File? _pickedImage;
  bool _isLoading = false; // To show a loading indicator on submit

  @override
  void initState() {
    super.initState();
    // Pre-fill form fields with existing data if available.
    // ref.read is safe to use in initState.
    final initialProfile = ref.read(userProfileProvider).valueOrNull;
    if (initialProfile != null) {
      _firstNameController.text = initialProfile.firstName;
      _lastNameController.text = initialProfile.lastName;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _trySubmit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authProvider).valueOrNull;
      if (user == null) {
        throw Exception("User not authenticated.");
      }

      // Get the current profile state. It will be null during initial setup.
      final currentProfile = ref.read(userProfileProvider).valueOrNull;

      // If an image was picked, upload it first.
      if (_pickedImage != null) {
        await ref
            .read(userProfileManagerProvider)
            .uploadNewUserProfileImage(_pickedImage!);
        _pickedImage = null; // Clear after upload
      }

      // THIS IS YOUR CORRECTED LOGIC, FULLY INTEGRATED:
      // It handles both the initial creation and subsequent updates.
      final UserProfile profileToSave;

      if (currentProfile == null) {
        // Profile doesn't exist, so create a new one from scratch.
        profileToSave = UserProfile(
          uid: user.uid,
          email: user.email ?? '',
          emailLowercase: (user.email ?? '').toLowerCase(),
          dateLastPasswordChange: DateTime.now(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          // Mark onboarding as complete right away
          accountCreationStep: AccountCreationStep.ACC_STEP_ONBOARDING_COMPLETE,
        );
      } else {
        // Profile exists, so create a copy with the updated fields.
        profileToSave = currentProfile.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          accountCreationStep: AccountCreationStep.ACC_STEP_ONBOARDING_COMPLETE,
        );
      }

      // Write the new or updated profile data to the database.
      await ref
          .read(userProfileManagerProvider)
          .writeUserProfile(profileToSave);

      if (mounted && !widget.isAuth) {
        Snackbar.show(
          SnackbarDisplayType.SB_SUCCESS,
          "Profile Updated",
          context,
        );
        context.pop();
      }
      // If isAuth is true, the GoRouter will now see the complete profile and redirect automatically.
    } catch (e) {
      if (mounted) {
        Snackbar.show(
          SnackbarDisplayType.SB_ERROR,
          "Failed to update profile: ${e.toString()}",
          context,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Picks an image from the specified source (gallery or camera).
  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: source,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  /// Removes the user's current profile image.
  Future<void> _removeImage() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(userProfileManagerProvider).removeUserProfileImage();
      setState(() => _pickedImage = null); // Also clear any staged image
      if (mounted) {
        Snackbar.show(
          SnackbarDisplayType.SB_SUCCESS,
          "Profile photo removed.",
          context,
        );
      }
    } catch (e) {
      if (mounted) {
        Snackbar.show(
          SnackbarDisplayType.SB_ERROR,
          "Failed to remove photo: ${e.toString()}",
          context,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers for reactive UI updates
    final userProfile = ref.watch(userProfileProvider).valueOrNull;
    final userImage = ref.watch(userProfileImageProvider).valueOrNull;

    return Scaffold(
      appBar: widget.isAuth
          ? null // No app bar during initial setup
          : AppBar(title: const Text("Edit Profile")),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  ProfileAvatar(
                    radius: 80,
                    userImage: _pickedImage != null
                        ? FileImage(_pickedImage!)
                        : userImage,
                    userWholeName: userProfile?.wholeName ?? "",
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildImageButton(
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                      _buildImageButton(
                        icon: CupertinoIcons.photo_camera,
                        label: 'Camera',
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      if (userImage != null || _pickedImage != null)
                        _buildImageButton(
                          icon: CupertinoIcons.delete,
                          label: 'Remove',
                          onPressed: _removeImage,
                          color: Colors.red,
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _firstNameController,
                    autofillHints: const [AutofillHints.givenName],
                    textCapitalization: TextCapitalization.words,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a first name.' : null,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    autofillHints: const [AutofillHints.familyName],
                    textCapitalization: TextCapitalization.words,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a last name.' : null,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _trySubmit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(widget.isAuth ? "Continue" : "Update Profile"),
                  ),
                  if (widget.isAuth)
                    TextButton(
                      onPressed: () =>
                          ref.read(authProvider.notifier).signOut(),
                      child: const Text("Sign Out"),
                    ),
                ],
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

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
