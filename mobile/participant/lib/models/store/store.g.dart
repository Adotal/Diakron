// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Store _$StoreFromJson(Map<String, dynamic> json) => _Store(
  id: json['id'] as String,
  commercialName: json['commercial_name'] as String,
  address: json['address'] as String,
  category: json['category'] as String,
  postCode: json['post_code'] as String,
  schedule: json['schedule'] as Map<String, dynamic>,
  pathLogo: json['path_logo'] as String,
  pointsExchanged: (json['points_exchanged'] as num?)?.toInt(),
);

Map<String, dynamic> _$StoreToJson(_Store instance) => <String, dynamic>{
  'id': instance.id,
  'commercial_name': instance.commercialName,
  'address': instance.address,
  'category': instance.category,
  'post_code': instance.postCode,
  'schedule': instance.schedule,
  'path_logo': instance.pathLogo,
  'points_exchanged': instance.pointsExchanged,
};
