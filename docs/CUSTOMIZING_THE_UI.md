# Guide: Customizing the UI

This guide explains how to customize the visual appearance of your application, including changing the theme and colors, and how to think about reusable widgets.

## Theme and Colors

The entire visual theme of the application is centralized in the `lib/core/theme/` directory. This allows you to make consistent changes to the look and feel of your app from one place.

### Changing Colors

1.  **Open `lib/core/theme/colors.dart`**.
2.  This file contains the color palette for the application, with specific colors defined for both light and dark modes (e.g., `primaryColorLight`, `primaryColorDark`).
3.  Modify the hex values in this file to match your brand's color scheme.

    ```dart
    // lib/core/theme/colors.dart
    import 'package:flutter/material.dart';

    // Example: Change the primary color for light mode
    const Color primaryColorLight = Color(0xFF6200EE); // 👈 Change this value
    const Color secondaryColorLight = Color(0xFF03DAC6);

    // Example: Change the primary color for dark mode
    const Color primaryColorDark = Color(0xFFBB86FC); // 👈 Change this value
    const Color secondaryColorDark = Color(0xFF03DAC6);
    ```

### Adjusting the Theme

1.  **Open `lib/core/theme/theme.dart`**.
2.  This file contains two `ThemeData` objects: `lightTheme` and `darkTheme`.
3.  Here you can adjust everything from default fonts and `AppBar` styles to `ElevatedButton` themes, using the colors you defined in `colors.dart`.

    ```dart
    // lib/core/theme/theme.dart

    // ...
    final lightTheme = ThemeData(
      // ...
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColorLight, // Using the color from colors.dart
        elevation: 4.0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorLight,
          foregroundColor: Colors.white,
        ),
      ),
      // ... other theme properties
    );
    ```

## Widgets: Shared vs. Feature-Specific

Organizing widgets effectively is key to a maintainable codebase. Here’s how to decide where a new widget should live.

### Shared Widgets (`lib/core/widgets/`)

A widget belongs in `lib/core/widgets/` if it is **completely generic and can be used by any feature without modification**.

-   **Examples**: A customized primary button, a standardized text input field, a loading indicator, or a profile avatar display.
-   **Rule of Thumb**: A shared widget should have no knowledge of the specific feature using it. It should be configured purely by the parameters passed into it.

**When to create a shared widget:**
When you find yourself building the same or a very similar widget for a second or third time, it's a good candidate for promotion to a shared widget in the `core` directory.

### Feature-Specific Widgets (`lib/features/*/widgets/`)

A widget belongs inside a feature's `widgets` directory (e.g., `lib/features/profile/widgets/`) if it is **tightly coupled to that feature**.

-   **Examples**: A user's profile header (which knows about the `UserProfile` model), a shopping cart item display, or a password strength indicator used only on the signup screen.
-   **Rule of Thumb**: If your widget directly reads a provider specific to one feature or is designed to work with a data model from only one feature, it belongs inside that feature's folder.

By following this separation, you keep your features self-contained and your shared component library clean and truly reusable.
