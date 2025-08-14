# Flutter Template: A Firebase & Riverpod Foundation

This project is a feature-rich starting point for a Flutter application, built with a modern, scalable, and maintainable architecture. It comes pre-configured with Firebase, Riverpod for state management, GoRouter for navigation, and a clear project structure designed for rapid development.

## Core Technologies & Libraries

This template integrates a curated set of best-in-class libraries to provide a robust foundation for your application.

-   **State Management**: [Riverpod](https://riverpod.dev/) is used for state management, with `riverpod_generator` for creating compile-safe providers. This offers a flexible and powerful approach to dependency injection and state management.
-   **Routing**: [Go Router](https://pub.dev/packages/go_router) handles all navigation. It's configured to be state-aware, automatically redirecting users based on their authentication and profile completion status.
-   **Backend & Auth**: [Firebase](https://firebase.google.com/) is the backend.
    -   **Authentication**: `firebase_auth` for user sign-up, sign-in, and session management.
    -   **Database**: `cloud_firestore` for storing user profile data.
    -   **Storage**: `firebase_storage` for user profile images.
-   **Immutable Models**: [Freezed](https://pub.dev/packages/freezed) is used for creating data models (e.g., `UserProfile`). This provides robust, immutable classes with pattern matching and JSON serialization support.
-   **Code Generation**: The project relies heavily on `build_runner` to generate code for Riverpod providers (`.g.dart`), Freezed models (`.freezed.dart`), and JSON serialization (`.g.dart`).

## Architecture Overview

The project follows a clean architecture pattern, separating concerns into three main layers: **Repositories**, **Providers**, and the **UI (Screens)**.

### 1. Models (`lib/models/`)

Data structures are defined here using the **Freezed** package for creating immutable, serializable classes. This is the foundation of the app's data layer.

> For a detailed guide on creating or modifying data models, see [lib/models/README.md](./lib/models/README.md).

### 2. Repositories (`lib/repositories/`)

Repositories are the sole mediators between the application and its data sources (e.g., Firestore, Firebase Storage). They encapsulate all data access logic (CRUD operations), ensuring that the rest of the app is decoupled from the specific data implementation.

> For a detailed guide on the repository pattern, see [lib/repositories/README.md](./lib/repositories/README.md).

### 3. Providers (`lib/providers/`)

Providers, using **Riverpod**, are the core of the application's logic and state management. They connect the UI to the repositories, manage application state, and expose business logic. This is where you'll find state notifiers, data streams, and computed state logic.

> For a detailed guide on using Riverpod providers, see [lib/providers/README.md](./lib/providers/README.md).

## Project Structure (`lib/`)

-   **`main.dart`**: The application's entry point. It initializes Firebase and sets up the Riverpod `ProviderScope`.
-   **`models/`**: Contains the data structures (see above).
-   **`providers/`**: The core of the application's logic and state (see above).
-   **`repositories/`**: Abstracts data layer operations (see above).
-   **`screens/`**: UI components representing full pages.
    -   `auth/`: Screens for the authentication and onboarding flow.
    -   `general/`: Screens for authenticated users.
-   **`widgets/`**: Reusable UI components used across multiple screens.
-   **`theme/`**: Defines the application's visual styling.
-   **`util/`**: Contains helper classes for common tasks.

## Getting Started

This guide will walk you through setting up the template for your own project.

### Step 1: Initial Project Setup

1.  **Clone the Repository**:
    ```sh
    git clone <your-repo-url>
    cd flutter_template
    ```

2.  **Install Dependencies**:
    Run the following command to fetch all the necessary Dart and Flutter packages.
    ```sh
    flutter pub get
    ```

### Step 2: Firebase Project Setup

This template is tightly integrated with Firebase. You will need to create your own Firebase project to connect to.

1.  **Create a Firebase Project**:
    -   Go to the [Firebase Console](https://console.firebase.google.com/).
    -   Click "Add project" and follow the on-screen instructions.

2.  **Enable Required Services**:
    In your new project's console, navigate to the "Build" section and enable the following services:
    -   **Authentication**: Go to the "Sign-in method" tab and enable the **Email/Password** provider.
    -   **Firestore Database**: Create a new database. You can start in **test mode** for easy setup.
    -   **Storage**: Enable Firebase Storage to handle file uploads (like profile pictures).

### Step 3: Connect Your App with FlutterFire

You'll use the FlutterFire CLI to connect your local app to your new Firebase project. This will automatically generate the necessary configuration file (`lib/firebase_options.dart`).

1.  **Install CLIs**:
    If you don't have them already, install the Firebase and FlutterFire command-line tools.
    ```sh
    # Install the Firebase CLI
    npm install -g firebase-tools

    # Install the FlutterFire CLI
    dart pub global activate flutterfire_cli
    ```

2.  **Configure Your App**:
    Run the following command from the root of your project directory:
    ```sh
    flutterfire configure
    ```
    -   The CLI will prompt you to log in to Firebase (`firebase login`).
    -   It will then display a list of your Firebase projects. Select the one you created in Step 2.
    -   It will ask which platforms to configure (iOS, Android, Web). Choose the ones you need.
    -   This process will create a new `lib/firebase_options.dart` file, linking your app to your Firebase backend.

### Step 4: Running the App & Ongoing Development

Once the setup is complete, you can run the application on your desired emulator or device.

**Code Generation**

This project uses `build_runner` to generate necessary files for models, providers, and serialization. After creating or modifying a model (`.dart` file in `lib/models/`) or a provider (`.dart` file in `lib/providers/`), you must run the generator to update the associated files:

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

This command will generate or update the `*.freezed.dart` and `*.g.dart` files. You should **never** edit these files manually.

## Authentication & Routing Flow

The application's navigation is driven by the user's authentication and profile completion status, managed by `GoRouter` and a `routingStateProvider`.

1.  **Initialization**: The app starts at the splash screen (`/splash`).
2.  **State Evaluation**: The router immediately checks the user's state.
3.  **Auth Check**:
    -   If the user is not authenticated, they are redirected to the login/signup flow (`/auth`).
4.  **Profile Check**:
    -   If a user is authenticated but has not completed their profile setup, they are redirected to the profile setup screen (`/profileSetup`).
5.  **Authenticated Access**:
    -   If the user is authenticated AND their profile is complete, they are allowed to access the main app routes (e.g., `/home`).

This logic is centralized in `lib/providers/app_router_provider.dart` and `lib/providers/routing_state_provider.dart`.