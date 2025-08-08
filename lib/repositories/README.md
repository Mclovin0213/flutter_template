# Repositories Directory

This directory contains repository classes responsible for abstracting data access from various data sources, such as Firebase Firestore and Firebase Storage. Repositories provide a clean API for interacting with data, decoupling the application's business logic from the underlying data storage mechanisms.

## `firestore_keys.dart`

This file defines constants for Firestore collection and document keys. Using constants ensures consistency across the application when referencing Firestore paths and makes maintenance easier by centralizing key definitions.

### Firestore Top-Level Collection Names

*   **`FS_COL_IC_USER_PROFILES`** (`String`): Represents the top-level Firestore collection name for user profiles (`'app_user_profiles'`).

### Firestore Mid-Level Collection/Document Names/Keys

This section is currently empty but is intended for future expansion to include keys for subcollections or specific document fields within top-level collections.

## `user_profile_repository.dart`

This file defines the `UserProfileRepository` class and its associated Riverpod provider, `userProfileRepositoryProvider`. This repository handles all data operations related to user profiles, including fetching, writing, uploading images, and deleting data from Firebase Firestore and Firebase Storage.

### `userProfileRepositoryProvider`

*   **Type**: `AutoDisposeProvider<UserProfileRepository>`
*   **Purpose**: Provides a singleton instance of `UserProfileRepository`, injecting the necessary Firebase service instances (`FirebaseAuth`, `FirebaseFirestore`, `FirebaseStorage`).

### `UserProfileRepository` Class

This class encapsulates all logic for interacting with user profile data in Firebase.

**Dependencies:**

*   `FirebaseAuth`: For managing user authentication state and retrieving the current user's UID.
*   `FirebaseFirestore`: For interacting with the Firestore database (e.g., reading and writing user profile documents).
*   `FirebaseStorage`: For managing user profile pictures in Firebase Storage.

**Properties:**

*   **`firebaseAuth`**: The injected `FirebaseAuth` instance.
*   **`firestore`**: The injected `FirebaseFirestore` instance.
*   **`firebaseStorage`**: The injected `FirebaseStorage` instance.
*   **`currentUser`** (`User?`): A getter that returns the currently authenticated Firebase `User`.
*   **`currentUserId`** (`String?`): A getter that returns the UID of the currently authenticated user.

**Private Methods:**

*   **`_getProfilePicturePath(String uid)`**: A helper method that constructs the Firebase Storage path for a user's profile picture based on their UID.

**Public Methods:**

*   **`Stream<UserProfile> getUserProfileStream()`**:
    *   **Purpose**: Provides a real-time stream of the `UserProfile` object for the current authenticated user.
    *   **Behavior**: Listens to changes in the Firestore document corresponding to the user's UID. If the user is not authenticated or the profile does not exist, it returns an error stream. It also injects the `uid` and `email` from the Firebase `User` object into the `UserProfile` data before deserialization.
*   **`Future<void> writeUserProfile(UserProfile userProfile, {bool merge = true})`**:
    *   **Purpose**: Writes or updates a `UserProfile` object to Firestore.
    *   **Parameters**:
        *   `userProfile`: The `UserProfile` object to write.
        *   `merge`: If `true`, merges the new data with existing data; otherwise, overwrites the document.
    *   **Behavior**: Requires an authenticated user. Throws an exception on failure.
*   **`Future<ImageProvider?> fetchUserProfileImage(String uid)`**:
    *   **Purpose**: Fetches the profile image for a given user ID from Firebase Storage.
    *   **Returns**: An `ImageProvider` if the image exists, otherwise `null`.
    *   **Behavior**: Handles cases where the image might not exist gracefully.
*   **`Future<void> uploadNewUserProfileImage(File imageFile)`**:
    *   **Purpose**: Uploads a new profile image file to Firebase Storage for the current authenticated user.
    *   **Behavior**: Requires an authenticated user. Attempts to retrieve existing metadata to preserve it during upload. Throws an exception on failure.
*   **`Future<void> deleteUserProfileImage()`**:
    *   **Purpose**: Deletes the current authenticated user's profile image from Firebase Storage.
    *   **Behavior**: Requires an authenticated user. Handles cases where the image might not exist gracefully.
*   **`Future<void> deleteUserProfileData()`**:
    *   **Purpose**: Deletes the user's profile document from Firestore.
    *   **Behavior**: Requires an authenticated user. Note that this method *does not* delete the Firebase Auth user itself.