# Tutorial: Adding a New Feature

This guide will walk you through the process of adding a new feature to the application. We will use a simple "Settings" page as our example.

By the end of this tutorial, you will have a new screen accessible from a button on the home screen.

---

### Step 1: Create the Feature Directory

First, create a new directory for your feature inside `lib/features/`. Our feature is named "settings".

```sh
# From the project root
mkdir -p lib/features/settings/screens
```

We also created a `screens` subdirectory to hold our UI files, following the established pattern.

---

### Step 2: Create the Screen File

Now, create the main screen file for your feature. Create a new file at `lib/features/settings/screens/settings_screen.dart`.

Add the following boilerplate code for a simple, stateless screen:

```dart
// lib/features/settings/screens/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('This is the settings page.'),
      ),
    );
  }
}
```

---

### Step 3: Add the Route to the Navigator

To make the new screen accessible, you must register it as a route in the application's navigator.

1.  **Open the router provider file**: `lib/core/providers/app_router_provider.dart`.
2.  **Import your new screen** at the top of the file:
    ```dart
    import 'package:flutter_template/features/settings/screens/settings_screen.dart';
    ```
3.  **Add a new `GoRoute`** to the list of routes within the `ShellRoute`. This ensures your new screen will have the primary app scaffold (the bottom navigation bar).

    Find the `routes` list inside the `ShellRoute` and add your new route definition:

    ```dart
    // lib/core/providers/app_router_provider.dart

    // ... other imports
    import 'package:flutter_template/features/home/screens/screen_home.dart';
    import 'package:flutter_template/features/general/screens/screen_alternate.dart';
    import 'package:flutter_template/features/settings/screens/settings_screen.dart'; // 👈 Add this import

    // ... provider definition

          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const ScreenHome(),
            ),
            GoRoute(
              path: '/alternate',
              builder: (context, state) => const ScreenAlternate(),
            ),
            // 👇 Add this new route
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
    // ... rest of the file
    ```

---

### Step 4: Navigate to the New Screen

Finally, let's add a button on the home screen to navigate to our new settings page.

1.  **Open the home screen file**: `lib/features/home/screens/screen_home.dart`.
2.  **Add a button** to the `body` of the `Scaffold`.
3.  **Use `GoRouter`** to navigate to the '/settings' path when the button is pressed.

    ```dart
    // lib/features/home/screens/screen_home.dart
    import 'package:flutter/material.dart';
    import 'package:go_router/go_router.dart'; // 👈 Make sure this is imported

    class ScreenHome extends StatelessWidget {
      const ScreenHome({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Home Screen'),
                const SizedBox(height: 20),
                // 👇 Add this button
                ElevatedButton(
                  onPressed: () {
                    // Use GoRouter to navigate
                    context.go('/settings');
                  },
                  child: const Text('Go to Settings'),
                ),
              ],
            ),
          ),
        );
      }
    }
    ```

---

### That's It!

You have successfully added a new feature to the application. You can now run the app, go to the home screen, and tap your new button to see the settings page.

As your feature grows, you can add `providers`, `models`, and `repositories` inside your `lib/features/settings/` directory to keep all related code organized together.
