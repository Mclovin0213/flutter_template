// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  @JsonKey(includeToJson: false, includeFromJson: false)
  String get uid => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_lowercase')
  String get emailLowercase => throw _privateConstructorUsedError;
  @JsonKey(name: 'permission_level')
  PermissionLevel get permissionLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_creation_time')
  int get accountCreationTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_last_password_change')
  @TimestampConverter()
  DateTime get dateLastPasswordChange => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_creation_step')
  AccountCreationStep get accountCreationStep =>
      throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {@JsonKey(includeToJson: false, includeFromJson: false) String uid,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      @JsonKey(name: 'email_lowercase') String emailLowercase,
      @JsonKey(name: 'permission_level') PermissionLevel permissionLevel,
      @JsonKey(name: 'account_creation_time') int accountCreationTime,
      @JsonKey(name: 'date_last_password_change')
      @TimestampConverter()
      DateTime dateLastPasswordChange,
      @JsonKey(name: 'account_creation_step')
      AccountCreationStep accountCreationStep});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? emailLowercase = null,
    Object? permissionLevel = null,
    Object? accountCreationTime = null,
    Object? dateLastPasswordChange = null,
    Object? accountCreationStep = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailLowercase: null == emailLowercase
          ? _value.emailLowercase
          : emailLowercase // ignore: cast_nullable_to_non_nullable
              as String,
      permissionLevel: null == permissionLevel
          ? _value.permissionLevel
          : permissionLevel // ignore: cast_nullable_to_non_nullable
              as PermissionLevel,
      accountCreationTime: null == accountCreationTime
          ? _value.accountCreationTime
          : accountCreationTime // ignore: cast_nullable_to_non_nullable
              as int,
      dateLastPasswordChange: null == dateLastPasswordChange
          ? _value.dateLastPasswordChange
          : dateLastPasswordChange // ignore: cast_nullable_to_non_nullable
              as DateTime,
      accountCreationStep: null == accountCreationStep
          ? _value.accountCreationStep
          : accountCreationStep // ignore: cast_nullable_to_non_nullable
              as AccountCreationStep,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeToJson: false, includeFromJson: false) String uid,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      @JsonKey(name: 'email_lowercase') String emailLowercase,
      @JsonKey(name: 'permission_level') PermissionLevel permissionLevel,
      @JsonKey(name: 'account_creation_time') int accountCreationTime,
      @JsonKey(name: 'date_last_password_change')
      @TimestampConverter()
      DateTime dateLastPasswordChange,
      @JsonKey(name: 'account_creation_step')
      AccountCreationStep accountCreationStep});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? emailLowercase = null,
    Object? permissionLevel = null,
    Object? accountCreationTime = null,
    Object? dateLastPasswordChange = null,
    Object? accountCreationStep = null,
  }) {
    return _then(_$UserProfileImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailLowercase: null == emailLowercase
          ? _value.emailLowercase
          : emailLowercase // ignore: cast_nullable_to_non_nullable
              as String,
      permissionLevel: null == permissionLevel
          ? _value.permissionLevel
          : permissionLevel // ignore: cast_nullable_to_non_nullable
              as PermissionLevel,
      accountCreationTime: null == accountCreationTime
          ? _value.accountCreationTime
          : accountCreationTime // ignore: cast_nullable_to_non_nullable
              as int,
      dateLastPasswordChange: null == dateLastPasswordChange
          ? _value.dateLastPasswordChange
          : dateLastPasswordChange // ignore: cast_nullable_to_non_nullable
              as DateTime,
      accountCreationStep: null == accountCreationStep
          ? _value.accountCreationStep
          : accountCreationStep // ignore: cast_nullable_to_non_nullable
              as AccountCreationStep,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl(
      {@JsonKey(includeToJson: false, includeFromJson: false) this.uid = "",
      @JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      required this.email,
      @JsonKey(name: 'email_lowercase') required this.emailLowercase,
      @JsonKey(name: 'permission_level')
      this.permissionLevel = PermissionLevel.PRODUCTION,
      @JsonKey(name: 'account_creation_time') this.accountCreationTime = 0,
      @JsonKey(name: 'date_last_password_change')
      @TimestampConverter()
      required this.dateLastPasswordChange,
      @JsonKey(name: 'account_creation_step') this.accountCreationStep =
          AccountCreationStep.ACC_STEP_ONBOARDING_PROFILE_CONTACT_INFO})
      : super._();

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String uid;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final String email;
  @override
  @JsonKey(name: 'email_lowercase')
  final String emailLowercase;
  @override
  @JsonKey(name: 'permission_level')
  final PermissionLevel permissionLevel;
  @override
  @JsonKey(name: 'account_creation_time')
  final int accountCreationTime;
  @override
  @JsonKey(name: 'date_last_password_change')
  @TimestampConverter()
  final DateTime dateLastPasswordChange;
  @override
  @JsonKey(name: 'account_creation_step')
  final AccountCreationStep accountCreationStep;

  @override
  String toString() {
    return 'UserProfile(uid: $uid, firstName: $firstName, lastName: $lastName, email: $email, emailLowercase: $emailLowercase, permissionLevel: $permissionLevel, accountCreationTime: $accountCreationTime, dateLastPasswordChange: $dateLastPasswordChange, accountCreationStep: $accountCreationStep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailLowercase, emailLowercase) ||
                other.emailLowercase == emailLowercase) &&
            (identical(other.permissionLevel, permissionLevel) ||
                other.permissionLevel == permissionLevel) &&
            (identical(other.accountCreationTime, accountCreationTime) ||
                other.accountCreationTime == accountCreationTime) &&
            (identical(other.dateLastPasswordChange, dateLastPasswordChange) ||
                other.dateLastPasswordChange == dateLastPasswordChange) &&
            (identical(other.accountCreationStep, accountCreationStep) ||
                other.accountCreationStep == accountCreationStep));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      firstName,
      lastName,
      email,
      emailLowercase,
      permissionLevel,
      accountCreationTime,
      dateLastPasswordChange,
      accountCreationStep);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {@JsonKey(includeToJson: false, includeFromJson: false) final String uid,
      @JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      required final String email,
      @JsonKey(name: 'email_lowercase') required final String emailLowercase,
      @JsonKey(name: 'permission_level') final PermissionLevel permissionLevel,
      @JsonKey(name: 'account_creation_time') final int accountCreationTime,
      @JsonKey(name: 'date_last_password_change')
      @TimestampConverter()
      required final DateTime dateLastPasswordChange,
      @JsonKey(name: 'account_creation_step')
      final AccountCreationStep accountCreationStep}) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  @JsonKey(includeToJson: false, includeFromJson: false)
  String get uid;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  String get email;
  @override
  @JsonKey(name: 'email_lowercase')
  String get emailLowercase;
  @override
  @JsonKey(name: 'permission_level')
  PermissionLevel get permissionLevel;
  @override
  @JsonKey(name: 'account_creation_time')
  int get accountCreationTime;
  @override
  @JsonKey(name: 'date_last_password_change')
  @TimestampConverter()
  DateTime get dateLastPasswordChange;
  @override
  @JsonKey(name: 'account_creation_step')
  AccountCreationStep get accountCreationStep;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
