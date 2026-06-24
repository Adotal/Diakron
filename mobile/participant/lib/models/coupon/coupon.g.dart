// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Coupon _$CouponFromJson(Map<String, dynamic> json) => _Coupon(
  id: (json['id'] as num?)?.toInt(),
  idStore: json['id_store'] as String,
  title: json['title'] as String,
  descript: json['descript'] as String,
  pricePoints: (json['price_points'] as num).toInt(),
  expirationDate: DateTime.parse(json['expiration_date'] as String),
  couponsLeft: (json['coupons_left'] as num?)?.toInt(),
  isActive: json['is_active'] as bool,
  pathImage: json['path_image'] as String,
);

Map<String, dynamic> _$CouponToJson(_Coupon instance) => <String, dynamic>{
  'id': instance.id,
  'id_store': instance.idStore,
  'title': instance.title,
  'descript': instance.descript,
  'price_points': instance.pricePoints,
  'expiration_date': instance.expirationDate.toIso8601String(),
  'coupons_left': instance.couponsLeft,
  'is_active': instance.isActive,
  'path_image': instance.pathImage,
};
