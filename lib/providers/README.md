# Working with Providers (Riverpod)

Providers are the heart of this template's architecture. They are used to provide data, manage state, and expose business logic to the UI in a clean, decoupled, and testable way. This project uses the [Riverpod](https://riverpod.dev/) state management library with its modern `riverpod_generator` syntax.

All providers should be placed in this `lib/providers/` directory.

## When to Create a Provider

You should create a provider whenever you need to:

1.  **Access Data**: Fetch data from a repository (like `UserProfileRepository`) and make it available to the UI. This is perfect for data that can change, like a stream from Firestore.
2.  **Manage State**: Hold state that can be modified by the user or the application, such as the current theme, a search query, or a list of items in a shopping cart.
3.  **Expose Business Logic**: Provide an object or class that contains business logic (e.g., `Auth` provider's `signInWithPassword` method) so it can be called from the UI without putting the logic directly in your widgets.
4.  **Compute Derived State**: Combine one or more providers to create a new piece of state. The `routingStateProvider` is a perfect example, as it combines the `authProvider` and `userProfileProvider` to determine the user's overall navigation state.

## How to Create a New Provider

This project uses `riverpod_generator`, which simplifies provider creation. Here are a few common patterns.

### Pattern 1: Providing Data from a Repository (Future or Stream)

This is the most common pattern for fetching data.

1.  **Create the file**: e.g., `lib/providers/product_provider.dart`.
2.  **Define the provider**: Use the `@riverpod` annotation on a function. Use `ref.watch` to depend on another provider (like your repository).

    ```dart
    // lib/providers/product_provider.dart
    import 'package:riverpod_annotation/riverpod_annotation.dart';
    import '../repositories/product_repository.dart'; // Assuming you created this
    import '../models/product.dart';

    part 'product_provider.g.dart';

    // This creates a FutureProvider that fetches a list of products
    @riverpod
    Future<List<Product>> productList(Ref ref) {
      // Get the repository and call the method to fetch data
      return ref.watch(productRepositoryProvider).fetchProducts();
    }

    // This creates a StreamProvider that listens for real-time updates
    @riverpod
    Stream<List<Product>> productStream(Ref ref) {
      return ref.watch(productRepositoryProvider).watchProducts();
    }
    ```

3.  **Run the generator**: Open your terminal and run:
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

### Pattern 2: Managing State and Logic (Notifier)

When you need to hold state that can be changed by user actions, use a `Notifier`. This is how `auth_provider.dart` is built.

1.  **Define your Notifier class**: It should extend the generated `_$[YourClassName]`.
2.  The `build` method defines the *initial state*.
3.  Public methods in your class can be called from the UI to modify the state.

    ```dart
    // lib/providers/cart_provider.dart
    import 'package:riverpod_annotation/riverpod_annotation.dart';
    import '../models/product.dart';

    part 'cart_provider.g.dart';

    @riverpod
    class Cart extends _$Cart {
      // The build method returns the initial state. Here, an empty list.
      @override
      List<Product> build() {
        return [];
      }

      // Public method to add a product to the cart
      void addProduct(Product product) {
        state = [...state, product]; // Update the state with a new list
      }

      // Public method to remove a product
      void removeProduct(String productId) {
        state = state.where((p) => p.id != productId).toList();
      }
    }
    ```
4.  **Run the generator** as shown above.

## How to Use Providers in Your Widgets

To use a provider, your widget must be a `ConsumerWidget` or `ConsumerStatefulWidget`.

```dart
class MyProductScreen extends ConsumerWidget {
  const MyProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use ref.watch() to get a provider's state and rebuild when it changes.
    // This is perfect for displaying data that can update.
    final AsyncValue<List<Product>> productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      // The .when() method is great for handling loading/error states
      body: productsAsync.when(
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(product.name),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Use ref.read(...).notifier to access the notifier class
                  // and call methods on it. Use read() in callbacks.
                  ref.read(cartProvider.notifier).addProduct(product);
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
```

- **`ref.watch()`**: Subscribes to a provider. Use it in the `build` method to make the UI react to state changes.
- **`ref.read()`**: Gets the current state *without* subscribing. Use it inside callbacks like `onPressed` to avoid unnecessary rebuilds.
- **`ref.read(myNotifierProvider.notifier)`**: Use this to get access to the notifier class itself so you can call its methods (e.g., `addProduct`).

## Modifying Existing Providers

Modifying the existing providers is straightforward.

- **To add a new method to `auth_provider` or `user_profile_provider`**: Simply open the file (e.g., `auth_provider.dart`), go into the `Auth` class, and add a new public method. You can then call this method from the UI using `ref.read(authProvider.notifier).yourNewMethod()`. You typically do not need to re-run the build runner for this.

- **To add a new dependency**: If your provider needs data from another provider, use `ref.watch()` or `ref.read()` inside its body. For example, the `userProfile` provider watches the `authProvider` to know when the user logs in or out.

- **To change the logic of `routingStateProvider`**: You can edit `routing_state_provider.dart` to add new conditions. For example, if you add a new `isSuspended` flag to your `UserProfile` model, you could add a check for it here and return a new `RoutingState.suspended` to redirect the user to a specific screen.
