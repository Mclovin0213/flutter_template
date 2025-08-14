// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileHash() => r'91e5e5c86e4e671e3b54d12e85950c6364d7cc5e';

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
String _$userProfileImageHash() => r'b460f682ff6a4745dab046bc05b8b16b069cba5f';

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
    r'c864640463c9ebecf8e109fa9db8838755ea0315';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
