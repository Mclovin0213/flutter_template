// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileHash() => r'c5b74a24d162df958f69f9c287d7ac75dc6e7719';

/// Provides a stream of the current authenticated user's [UserProfile] object.
/// It watches the `authProvider` to react to user login/logout events.
///
/// Copied from [userProfile].
@ProviderFor(userProfile)
final userProfileProvider = AutoDisposeStreamProvider<UserProfile>.internal(
  userProfile,
  name: r'userProfileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileRef = AutoDisposeStreamProviderRef<UserProfile>;
String _$userProfileImageHash() => r'890f248543cbac8e93c57a03afbcc95377d4cb6d';

/// Provides the profile image for the current authenticated user as a [Future<ImageProvider?>].
/// It depends on the `userProfileProvider` to get the user's UID.
///
/// Copied from [userProfileImage].
@ProviderFor(userProfileImage)
final userProfileImageProvider =
    AutoDisposeFutureProvider<ImageProvider?>.internal(
  userProfileImage,
  name: r'userProfileImageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileImageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileImageRef = AutoDisposeFutureProviderRef<ImageProvider?>;
String _$userProfileManagerHash() =>
    r'22b9e82984d2f71f9b347b813417c3894f5e8fd9';

/// Provides methods for performing actions related to the user profile,
/// such as writing data, uploading/removing images, and deleting account data.
/// It doesn't hold direct state but facilitates operations via the repository.
///
/// Copied from [userProfileManager].
@ProviderFor(userProfileManager)
final userProfileManagerProvider =
    AutoDisposeProvider<UserProfileManager>.internal(
  userProfileManager,
  name: r'userProfileManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileManagerRef = AutoDisposeProviderRef<UserProfileManager>;
String _$authHash() => r'dcade233f4685c0410fa83d0222cfcb2dafb3f91';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = AutoDisposeStreamNotifierProvider<Auth, User?>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = AutoDisposeStreamNotifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
