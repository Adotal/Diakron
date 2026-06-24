// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Collector _$CollectorFromJson(Map<String, dynamic> json) => _Collector(
  id: json['id'] as String,
  email: json['email'] as String,
  userName: json['user_name'] as String,
  surnames: json['surnames'] as String,
  phoneNumber: json['phone_number'] as String,
  isActive: json['is_active'] as bool,
  userType: json['user_type'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  mpAccessToken: json['mp_access_token'] as String?,
);

Map<String, dynamic> _$CollectorToJson(_Collector instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'user_name': instance.userName,
      'surnames': instance.surnames,
      'phone_number': instance.phoneNumber,
      'is_active': instance.isActive,
      'user_type': instance.userType,
      'created_at': instance.createdAt.toIso8601String(),
      'mp_access_token': instance.mpAccessToken,
    };
