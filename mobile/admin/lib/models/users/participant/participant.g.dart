// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Participant _$ParticipantFromJson(Map<String, dynamic> json) => _Participant(
  email: json['email'] as String?,
  id: json['id'] as String,
  userName: json['user_name'] as String?,
  surnames: json['surnames'] as String?,
  phoneNumber: json['phone_number'] as String?,
  isActive: json['is_active'] as bool?,
  userType: json['user_type'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  points: (json['points'] as num).toInt(),
  phrase: json['phrase'] as String?,
);

Map<String, dynamic> _$ParticipantToJson(_Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'surnames': instance.surnames,
      'phone_number': instance.phoneNumber,
      'is_active': instance.isActive,
      'user_type': instance.userType,
      'created_at': instance.createdAt?.toIso8601String(),
      'points': instance.points,
    };
