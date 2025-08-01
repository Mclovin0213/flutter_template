# Flutter Application Template

This repository contains a comprehensive Flutter application template designed to provide a solid foundation for building scalable and maintainable mobile applications. It incorporates modern state management, routing, and data modeling solutions, along with Firebase integration for backend services.

## Core Technologies

- **State Management**: `flutter_riverpod` with `riverpod_generator`
- **Backend**: Firebase (`firebase_auth`, `cloud_firestore`, `firebase_storage`)
- **Routing**: `go_router`
- **Models**: `freezed`

## Core Architecture

The application follows a 3-layer architecture:

- **UI Layer (`lib/presentation`)**: Contains all user interface components, including Widgets, Screens, and Riverpod AsyncNotifier Controllers responsible for UI-specific state and logic.
- **Data Layer (`lib/data`)**: Houses Repository classes that abstract all Firebase API calls, providing a clean interface for data operations.
- **Domain Layer (`lib/domain`)**: Defines the core data models using `freezed`, ensuring immutability and simplifying data handling.

## Directory Structure
```
lib/
├── core/                 # Core setup, shared utilities
├── domain/               # Data models (Freezed)
│   └── models/
├── data/                 # Repositories
│   └── repositories/
├── presentation/         # UI Layer
│   ├── controllers/      # Riverpod Notifiers
│   ├── providers/        # Simple providers
│   ├── screens/
│   │   ├── auth/         # Login, Signup
│   │   ├── core/         # Splash, App Shell
│   │   └── main/         # Screens for bottom nav
│   └── widgets/          # Reusable widgets
├── routing/              # GoRouter configuration
└── main.dart             # App entry point
```

## Setup and Installation

1.  **Clone the repository**:
    ```bash
    git clone [repository_url]
    cd flutter_template
    ```

2.  **Install Flutter dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Firebase Project Setup**:
    *   Create a new Firebase project in the [Firebase console](https://console.firebase.google.com/).
    *   Follow the official Firebase documentation to configure your Flutter app for both Android and iOS. This typically involves:
        *   Installing the Firebase CLI: `npm install -g firebase-tools`
        *   Logging in: `firebase login`
        *   Configuring your project: `flutterfire configure` (or manually adding `google-services.json` for Android and `GoogleService-Info.plist` for iOS).

4.  **Generate Code**:
    This project uses `freezed` and `riverpod_generator` for code generation. After adding or modifying models/providers, run:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Run the application**:
    ```bash
    flutter run
    ```

## Key Features Implemented

-   **Authentication Flow**: User login and signup using Firebase Authentication.
-   **User Profile Management**: Basic user profile creation and retrieval using Cloud Firestore.
-   **Routing**: `go_router` for declarative navigation, including authentication-based redirects and a shell route for persistent navigation.
-   **State Management**: `flutter_riverpod` for efficient and testable state management.
-   **Data Models**: Immutable data models generated with `freezed`.

## Extending the Template

-   **Add new features**: Follow the 3-layer architecture. Define new models in the `domain` layer, implement data operations in the `data` layer (repositories), and manage UI state and presentation in the `presentation` layer (controllers, screens, widgets).
-   **Firebase Services**: Extend existing repositories or create new ones for other Firebase services like Cloud Storage, Cloud Functions, etc.
-   **UI Components**: Create reusable widgets in `lib/presentation/widgets/`.