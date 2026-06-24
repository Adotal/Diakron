// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Admin _$AdminFromJson(Map<String, dynamic> json) => _Admin(
  email: json['email'] as String?,
  id: json['id'] as String?,
  userName: json['user_name'] as String?,
  surnames: json['surnames'] as String?,
  phoneNumber: json['phone_number'] as String?,
  isActive: json['is_active'] as bool?,
  userType: json['user_type'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  isSuperadmin: json['is_superadmin'] as bool?,
);

Map<String, dynamic> _$AdminToJson(_Admin instance) => <String, dynamic>{
  'id': instance.id,
  'user_name': instance.userName,
  'surnames': instance.surnames,
  'phone_number': instance.phoneNumber,
  'is_active': instance.isActive,
  'user_type': instance.userType,
  'created_at': instance.createdAt?.toIso8601String(),
  'is_superadmin': instance.isSuperadmin,
};
