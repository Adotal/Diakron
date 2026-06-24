// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incentive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Incentive _$IncentiveFromJson(Map<String, dynamic> json) => _Incentive(
  id: (json['id'] as num?)?.toInt(),
  idStore: json['id_store'] as String,
  amount: (json['amount'] as num).toInt(),
  repPercentage: (json['rep_percentage'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$IncentiveToJson(_Incentive instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_store': instance.idStore,
      'amount': instance.amount,
      'rep_percentage': instance.repPercentage,
      'created_at': instance.createdAt.toIso8601String(),
    };
