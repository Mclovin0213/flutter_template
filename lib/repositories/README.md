# Working with Repositories

This directory contains repositories, which are a core part of the app's architecture. The repository pattern is used to separate the application's business logic from the data access logic.

## The Role of a Repository

A repository's only job is to mediate between the app's data sources (like Firebase) and the rest of the application (specifically, the providers). It encapsulates all the logic needed to perform CRUD (Create, Read, Update, Delete) operations for a specific type of data.

**In this template, a repository is the *only* place where you should directly interact with `FirebaseFirestore`, `FirebaseStorage`, or any other external API.**

This provides several key benefits:
- **Decoupling**: Your providers and UI widgets don't need to know *how* data is stored or fetched. They just ask the repository for what they need.
- **Centralization**: All data operations for a feature (e.g., everything related to user profiles) are located in one file, making them easy to find and manage.
- **Testability**: When testing a provider, you can easily provide a mock (fake) version of its repository, allowing you to test the provider's logic in isolation without needing a real database connection.

## How to Create a New Repository

Let's say you want to manage a collection of `Product` objects in Firestore. Here's how you would create a `ProductRepository`.

### Step 1: Define Firestore Keys

To avoid typos, add your new collection name as a constant in `lib/repositories/firestore_keys.dart`.

```dart
// lib/repositories/firestore_keys.dart
const String FS_COL_PRODUCTS = 'products';
```

### Step 2: Create the Repository File

Create a new file: `lib/repositories/product_repository.dart`.

### Step 3: Write the Repository Class

The class should contain methods for each data operation you need. It will take its dependencies (like `FirebaseFirestore`) in its constructor.

```dart
// lib/repositories/product_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart'; // Your Freezed model
import 'firestore_keys.dart';

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository(this._firestore);

  // Method to get a stream of products
  Stream<List<Product>> watchProducts() {
    return _firestore
        .collection(FS_COL_PRODUCTS)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromJson(doc.data()))
          .toList();
    });
  }

  // Method to add a new product
  Future<void> addProduct(Product product) {
    return _firestore
        .collection(FS_COL_PRODUCTS)
        .doc(product.id)
        .set(product.toJson());
  }
}
```

### Step 4: Create the Riverpod Provider

In the **same file** (`product_repository.dart`), create a Riverpod provider to make your repository available to the rest of the app. This is done using the `@riverpod` annotation.

```dart
// Add these imports
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repository.g.dart'; // Required for generator

// ... your ProductRepository class here ...

// This provider creates and provides the ProductRepository instance
@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository(FirebaseFirestore.instance);
}
```

### Step 5: Run the Code Generator

Finally, run the build runner to generate the `*.g.dart` file for your new provider.

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

## How to Use a Repository

Repositories should **never** be accessed directly from the UI (widgets). They should only be used by **providers**.

The flow is always: **Widget -> Provider -> Repository -> Data Source**

Here is how a `productStreamProvider` would use the new `productRepositoryProvider`:

```dart
// In lib/providers/product_provider.dart

@riverpod
Stream<List<Product>> productStream(ProductStreamRef ref) {
  // Watch the repository provider to get the repository instance
  final productRepository = ref.watch(productRepositoryProvider);
  // Call the repository method to get the data stream
  return productRepository.watchProducts();
}
```

## Modifying the `UserProfileRepository`

If you need to add a new data operation related to user profiles, you should add a new method to the `UserProfileRepository` class.

For example, to add a function that updates a user's `bio`:

1.  **Add the method to `UserProfileRepository`** in `user_profile_repository.dart`:

    ```dart
    class UserProfileRepository {
      // ... existing methods ...

      Future<void> updateUserBio(String bio) async {
        final user = currentUser;
        if (user == null) {
          throw Exception("User not authenticated.");
        }
        await firestore
            .collection('user_profiles')
            .doc(user.uid)
            .update({'bio': bio});
      }
    }
    ```

2.  **Expose the logic through a provider.** You would typically add a corresponding method to the `UserProfileManager` class in `user_profile_provider.dart` which then calls this new repository method.

3.  **Call the provider's method** from your UI (e.g., from a button's `onPressed` callback).
