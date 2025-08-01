# Setup and Installation Guide

This guide provides detailed instructions on how to set up your development environment and get the Flutter application running.

## 1. Prerequisites

Before you begin, ensure you have the following installed on your system:

-   **Flutter SDK**: Follow the official Flutter installation guide for your operating system: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
-   **Dart SDK**: Included with Flutter SDK.
-   **Firebase CLI**:
    -   Node.js and npm (or yarn) are required. If you don't have them, install Node.js from [https://nodejs.org/](https://nodejs.org/).
    -   Install the Firebase CLI globally:
        ```bash
        npm install -g firebase-tools
        ```
-   **IDE**: Visual Studio Code with the Flutter extension, or Android Studio with the Flutter and Dart plugins.

## 2. Project Setup

1.  **Clone the repository**:
    If you haven't already, clone the project repository to your local machine:
    ```bash
    git clone [repository_url]
    cd flutter_template
    ```

2.  **Install Flutter dependencies**:
    Navigate to the project root directory in your terminal and run:
    ```bash
    flutter pub get
    ```
    This command fetches all the packages listed in `pubspec.yaml`.

## 3. Firebase Project Configuration

This application uses Firebase for authentication, Firestore, and Storage. You need to set up your own Firebase project and link it to this Flutter application.

1.  **Create a Firebase Project**:
    -   Go to the [Firebase console](https://console.firebase.google.com/).
    -   Click "Add project" and follow the on-screen instructions to create a new Firebase project.

2.  **Configure Flutter App with Firebase**:
    You can use the Firebase CLI to automatically configure your Flutter app.

    -   **Login to Firebase CLI**:
        ```bash
        firebase login
        ```
        This will open a browser window for you to authenticate with your Google account.

    -   **Configure your Flutter project**:
        Run the `flutterfire configure` command from your Flutter project's root directory:
        ```bash
        flutterfire configure
        ```
        Follow the prompts to select your Firebase project and the platforms (Android, iOS) you want to configure. This command will:
        -   Create a `lib/firebase_options.dart` file with your Firebase project configuration.
        -   Add necessary Firebase configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) to your platform-specific project directories.

    *Self-Correction/Manual Configuration (if `flutterfire configure` fails or for advanced setup)*:
    -   **Android**: Download `google-services.json` from your Firebase project settings (Project settings > General > Your apps) and place it in `android/app/`.
    -   **iOS**: Download `GoogleService-Info.plist` from your Firebase project settings and place it in `ios/Runner/`. Ensure it's added to your Xcode project.

## 4. Generate Code

This project uses code generation for `freezed` models and `riverpod_generator` providers. After making changes to `.dart` files that use these annotations (e.g., `app_user.dart`, `firebase_providers.dart`, `auth_controller.dart`, `app_router.dart`), you must run the build runner:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
It's good practice to run this command after `flutter pub get` or whenever you add/modify code-generated files.

## 5. Run the Application

Once all dependencies are installed and code is generated, you can run the application on a connected device or emulator:

```bash
flutter run
```

This will build and launch the application. You should see the splash screen, followed by the login screen.