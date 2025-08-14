// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      emailLowercase: json['email_lowercase'] as String,
      permissionLevel: $enumDecodeNullable(
              _$PermissionLevelEnumMap, json['permission_level']) ??
          PermissionLevel.PRODUCTION,
      accountCreationTime:
          (json['account_creation_time'] as num?)?.toInt() ?? 0,
      dateLastPasswordChange: const TimestampConverter()
          .fromJson(json['date_last_password_change'] as Timestamp),
      accountCreationStep: $enumDecodeNullable(
              _$AccountCreationStepEnumMap, json['account_creation_step']) ??
          AccountCreationStep.ACC_STEP_ONBOARDING_PROFILE_CONTACT_INFO,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'email_lowercase': instance.emailLowercase,
      'permission_level': _$PermissionLevelEnumMap[instance.permissionLevel]!,
      'account_creation_time': instance.accountCreationTime,
      'date_last_password_change':
          const TimestampConverter().toJson(instance.dateLastPasswordChange),
      'account_creation_step':
          _$AccountCreationStepEnumMap[instance.accountCreationStep]!,
    };

const _$PermissionLevelEnumMap = {
  PermissionLevel.PRODUCTION: 'PRODUCTION',
  PermissionLevel.BETA: 'BETA',
  PermissionLevel.DEVELOPER: 'DEVELOPER',
};

const _$AccountCreationStepEnumMap = {
  AccountCreationStep.ACC_STEP_ONBOARDING_PROFILE_CONTACT_INFO:
      'ACC_STEP_ONBOARDING_PROFILE_CONTACT_INFO',
  AccountCreationStep.ACC_STEP_ONBOARDING_COMPLETE:
      'ACC_STEP_ONBOARDING_COMPLETE',
};
