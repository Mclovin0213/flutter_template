# Working with Data Models

This project uses the [freezed](https://pub.dev/packages/freezed) package to create immutable and serializable data models. This approach ensures that your data objects are robust, predictable, and can be easily converted to and from JSON for storing in Firestore.

All data models should be placed in this `lib/models/` directory.

## Creating a New Data Model

Here’s how to create a new data model for your application, for example, a `Product` model.

### Step 1: Create the File

Create a new file in this directory, e.g., `lib/models/product.dart`.

### Step 2: Define the Model with Freezed

Set up the basic structure of your class using the `@freezed` annotation and `part` directives.

```dart
// lib/models/product.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    @JsonKey(name: 'in_stock') @Default(0) int inStock,
    double? price,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

**Key Elements:**
- **`@freezed`**: Marks the class for code generation by the Freezed package.
- **`part '....';`**: These lines are required to link to the files that `build_runner` will generate.
- **`factory Product(...)`**: This is where you define the properties of your model.
- **`@JsonKey(name: '...')`**: Use this to map a Dart field to a different name in your JSON/Firestore document. For example, `inStock` in Dart maps to `in_stock` in Firestore.
- **`@Default(...)`**: Provides a default value for a field. This is crucial for preventing errors if a document in Firestore is missing that field.
- **`factory Product.fromJson(...)`**: This tells `json_serializable` how to create a `Product` object from a JSON map.

### Step 3: Run the Code Generator

After defining your model, you must run the `build_runner` to generate the necessary `.freezed.dart` and `.g.dart` files. Open your terminal and run:

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

This command will generate `product.freezed.dart` and `product.g.dart`. You should **never** edit these files manually.

### Step 4 (Optional): Add Custom Methods or Getters

If you need to add custom logic to your model (like a formatted price string), add a private constructor and define your methods below it.

```dart
@freezed
class Product with _$Product {
  const factory Product({
    // ... properties
  }) = _Product;

  // Add this private constructor
  const Product._(); 

  // Now you can add custom getters or methods
  String get formattedPrice => price != null ? '\$${price!.toStringAsFixed(2)}' : 'N/A';
  bool get isAvailable => inStock > 0;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
```

## Modifying the `UserProfile` Model

You can easily adapt the existing `UserProfile` model to fit your application's needs.

### To Add a New Field:

1.  **Open `lib/models/user_profile.dart`**.
2.  **Add the new property** to the `factory UserProfile` constructor.
    -   For example, to add a user's bio, you could add `String? bio`.
3.  **Add annotations** as needed:
    -   Use `@JsonKey(name: 'user_bio')` if the field name in Firestore is different.
    -   Use `@Default('No bio available')` if it's a non-nullable field and you need a default value for existing users.
4.  **Re-run the build runner**:
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

### To Remove a Field:

1.  **Open `lib/models/user_profile.dart`**.
2.  **Delete the property** from the `factory UserProfile` constructor.
3.  **Re-run the build runner**.

> **Important**: When you modify a model, remember to update any UI or logic that depends on it (e.g., the `ScreenProfileSetup` form). You may also need to update your Firestore database rules or perform a data migration if the changes are significant.

## Handling Special Data Types (like Timestamps)

Firestore uses `Timestamp` objects for dates, while Dart uses `DateTime`. To handle this automatically, you can create a `JsonConverter`. The `UserProfile` model already includes a `TimestampConverter` for this purpose.

```dart
// In user_profile.dart

// 1. The converter class
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

// 2. How to use it on a field
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    // ... other fields
    @TimestampConverter() // Apply the converter here
    required DateTime dateLastPasswordChange,
  }) = _UserProfile;
  // ...
}
```

You can create your own converters for other special data types you might need.
