import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    String? displayName,
  }) = _AppUser;

  factory AppUser.fromFirebaseAuth(User user) => AppUser(
    uid: user.uid,
    email: user.email ?? '',
    displayName: user.displayName,
  );

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
