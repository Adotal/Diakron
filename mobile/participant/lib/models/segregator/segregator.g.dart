// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segregator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Segregator _$SegregatorFromJson(Map<String, dynamic> json) => _Segregator(
  id: (json['id'] as num).toInt(),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  isActive: json['is_active'] as bool,
  payloadQr: json['payload_qr'] as String?,
  description: json['description'] as String?,
  bins: (json['bins'] as List<dynamic>)
      .map((e) => BinModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SegregatorToJson(_Segregator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_active': instance.isActive,
      'payload_qr': instance.payloadQr,
      'description': instance.description,
      'bins': instance.bins,
    };
