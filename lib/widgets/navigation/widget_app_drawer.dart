// Flutter external package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// App relative file imports
import '../../screens/settings/screen_profile_edit.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_profile_provider.dart'; // Import the new user profile provider
import '../general/widget_profile_avatar.dart';

enum BottomNavSelection { HOME_SCREEN, ALTERNATE_SCREEN }

class WidgetAppDrawer extends ConsumerWidget {
  const WidgetAppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    // Watch the profile image provider separately.
    final userImageAsync = ref.watch(userProfileImageProvider);

    return Drawer(
      // Use the .when() method to build the UI based on the state of the user profile data.
      child: userProfileAsync.when(
        // Data is available, so build the full drawer UI.
        data: (userProfile) {
          // Get the actual ImageProvider? from its async value.
          // .value returns the data if available, or null if in a loading/error state.
          final userImage = userImageAsync.value;

          return Column(
            children: <Widget>[
              AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ProfileAvatar(
                      radius: 15,
                      // Pass the fetched image and user's full name from the new models.
                      userImage: userImage,
                      userWholeName: userProfile.wholeName,
                    ),
                    const SizedBox(width: 10),
                    // Use the first name from the UserProfile model.
                    Text('Welcome ${userProfile.firstName}'),
                  ],
                ),
                automaticallyImplyLeading: false,
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  // Just close the drawer. Assumes this drawer is on the home screen.
                  Navigator.of(context).pop();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  // Close the drawer before navigating to prevent UI issues.
                  Navigator.of(context).pop();
                  // Use go_router to navigate to the profile edit screen.
                  context.push(ScreenProfileEdit.routeName);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  // Call the signOut method from the Auth notifier.
                  // The go_router's refresh listener will handle redirection automatically,
                  // so there is no need to pop the navigator manually.
                  ref.read(authProvider.notifier).signOut();
                },
              ),
            ],
          );
        },
        // Show a loading indicator while the user profile is being fetched.
        loading: () => const Center(child: CircularProgressIndicator()),
        // Show a user-friendly error message if fetching the profile failed.
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Could not load profile.\nPlease try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ),
    );
  }
}
