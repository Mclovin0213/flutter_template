import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/data/repositories/auth_repository.dart';
import 'package:flutter_template/data/repositories/user_repository.dart';
import 'package:flutter_template/domain/models/app_user.dart';
import 'package:flutter_template/presentation/providers/repository_providers.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Stream<AppUser?> build() {
    return ref.watch(authRepositoryProvider).authStateChanges().map((user) {
      if (user == null) {
        return null;
      }
      return AppUser.fromFirebaseAuth(user);
    });
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);
  UserRepository get _userRepository => ref.read(userRepositoryProvider);

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signInWithEmail(email, password);
      final user = _authRepository.authStateChanges().firstWhere(
        (user) => user != null,
      );
      return AppUser.fromFirebaseAuth(await user as User);
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.signUpWithEmail(email, password);
      final user = _authRepository.authStateChanges().firstWhere(
        (user) => user != null,
      );
      await _userRepository.createUserProfile(
        AppUser.fromFirebaseAuth(await user as User),
      );
      return AppUser.fromFirebaseAuth(await user as User);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await AsyncValue.guard(() => _authRepository.signOut());
    state = const AsyncData(null);
  }
}
