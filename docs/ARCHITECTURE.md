# Application Architecture

This Flutter application template is structured around a clear, layered architecture to promote separation of concerns, maintainability, and scalability. The core principle is to divide the application into three distinct layers: UI, Data, and Domain.

## 1. UI Layer (Presentation Layer)

-   **Location**: `lib/presentation/`
-   **Purpose**: Responsible for everything the user sees and interacts with. It translates user input into actions and displays data received from the Domain Layer.
-   **Components**:
    -   **Screens (`lib/presentation/screens/`)**: Top-level widgets that represent entire pages or major sections of the application (e.g., `LoginScreen`, `HomeScreen`). They compose smaller widgets and interact with controllers/providers.
    -   **Widgets (`lib/presentation/widgets/`)**: Reusable UI components that are independent of specific business logic (e.g., custom buttons, input fields, cards).
    -   **Controllers (`lib/presentation/controllers/`)**: Implemented using Riverpod's `AsyncNotifier` (or `Notifier`/`StateNotifier`). These classes manage the UI state, handle user interactions, and orchestrate data flow between the UI and the Domain Layer. They do not contain direct business logic but rather call methods on repositories or use cases (if a separate use case layer were introduced).
    -   **Providers (`lib/presentation/providers/`)**: Simple Riverpod providers that expose instances of Firebase services, repositories, or other dependencies to the UI layer. This promotes dependency injection and testability.

## 2. Data Layer

-   **Location**: `lib/data/`
-   **Purpose**: Handles all data retrieval, storage, and manipulation. It abstracts the underlying data sources (e.g., Firebase, local storage, external APIs) from the rest of the application.
-   **Components**:
    -   **Repositories (`lib/data/repositories/`)**: Classes that define contracts for data operations. They encapsulate the logic for interacting with specific data sources. For example, `AuthRepository` handles all Firebase Authentication calls, and `UserRepository` manages Firestore operations related to user profiles. Repositories return domain models, ensuring the data is always in a consistent format.

## 3. Domain Layer

-   **Location**: `lib/domain/`
-   **Purpose**: Contains the core business logic and data models of the application. It is independent of any specific UI framework or data source.
-   **Components**:
    -   **Models (`lib/domain/models/`)**: Data structures that represent the core entities of the application (e.g., `AppUser`). These models are defined using `freezed` to ensure immutability, provide value equality, and simplify JSON serialization/deserialization.

## Data Flow

1.  **User Interaction (UI Layer)**: A user interacts with a widget on a screen.
2.  **Controller Action (UI Layer)**: The widget dispatches an action to a Riverpod controller (e.g., `AuthController.signIn()`).
3.  **Repository Call (Data Layer)**: The controller calls a method on a relevant repository (e.g., `AuthRepository.signInWithEmail()`).
4.  **Data Source Interaction (Data Layer)**: The repository interacts with the actual data source (e.g., Firebase Authentication, Cloud Firestore).
5.  **Data Transformation (Data Layer)**: The data received from the data source is transformed into a Domain Model.
6.  **Data Return (Domain Layer to UI Layer)**: The Domain Model is returned through the repository to the controller.
7.  **UI Update (UI Layer)**: The controller updates its state, which in turn triggers a rebuild of the relevant UI components, displaying the new data to the user.

This layered approach ensures that changes in one layer (e.g., switching from Firebase to another backend) have minimal impact on other layers, making the application more robust and easier to maintain.