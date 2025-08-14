# Architecture: Feature-First

This project is built using a **Feature-First** architecture. This is a deliberate choice to ensure the codebase is scalable, maintainable, and easy for developers to navigate.

## The Philosophy

The core idea is simple: **code that changes together should live together.**

In a traditional **layer-first** architecture, files are grouped by their technical type (e.g., `screens`, `providers`, `models`). To work on a single feature, you might have to edit files in many different directories. As the project grows, this can lead to a high cognitive load and makes it difficult to see the boundaries of a feature.

With **Feature-First**, we group files by the feature they implement. All the screens, providers, models, and repositories for the "profile" feature, for example, are located within the `lib/features/profile` directory. This makes features highly cohesive and loosely coupled from each other.

## Core Directories Explained

### `lib/features/`

This is the heart of the application. Each subdirectory within `features/` is a self-contained vertical slice of the application's functionality.

-   A feature should, as much as possible, be independent of other features.
-   Each feature folder can contain its own subdirectories for `screens`, `providers`, `models`, `repositories`, and feature-specific `widgets`.
-   When you start a new piece of functionality, your first step should be to create a new directory for it here.

**Example: A `cart` feature directory**
```
lib/features/cart/
├── models/
│   └── cart_item.dart
├── providers/
│   └── cart_provider.dart
├── screens/
│   └── cart_screen.dart
└── widgets/
    └── cart_total_display.dart
```

### `lib/core/`

This directory is for code that is **truly shared and used across multiple features**. It is the foundational layer of the application.

-   **Think carefully before adding code here.** If a piece of code is only used by one feature, it belongs in that feature's folder.
-   Code in `core/` should be generic and abstract, with no knowledge of the specific features that might use it.

**`core/` contains subdirectories like:**

-   `navigation/`: The main application scaffold (`WidgetPrimaryScaffold`) that provides the consistent look and feel (e.g., `AppBar`, `BottomNavigationBar`).
-   `providers/`: App-level providers that manage global state, such as routing (`app_router_provider.dart`).
-   `theme/`: The application's visual styling (colors, typography, theme data).
-   `utils/`: Generic helper classes and functions (e.g., logging, message display).
-   `widgets/`: Truly generic and reusable widgets that can be used by any feature (e.g., a generic loading indicator or a primary button).
