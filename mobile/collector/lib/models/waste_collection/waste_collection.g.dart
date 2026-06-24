// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WasteCollection _$WasteCollectionFromJson(Map<String, dynamic> json) =>
    _WasteCollection(
      id: (json['id'] as num).toInt(),
      idWasteType: (json['id_waste_type'] as num).toInt(),
      idSegregator: (json['id_segregator'] as num).toInt(),
      collDate: DateTime.parse(json['coll_date'] as String),
      isComplete: json['is_complete'] as bool,
      idCollectionCenter: json['id_collection_center'] as String?,
      ccenterName: json['ccenter_name'] as String?,
      paymentDate: json['payment_date'] == null
          ? null
          : DateTime.parse(json['payment_date'] as String),
      massGrams: (json['mass_grams'] as num?)?.toInt(),
      bruteAmount: (json['brute_amount'] as num?)?.toDouble(),
      commission: (json['commission'] as num?)?.toDouble(),
      netAmount: (json['net_amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WasteCollectionToJson(_WasteCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_waste_type': instance.idWasteType,
      'id_segregator': instance.idSegregator,
      'coll_date': instance.collDate.toIso8601String(),
      'is_complete': instance.isComplete,
      'id_collection_center': instance.idCollectionCenter,
      'ccenter_name': instance.ccenterName,
      'payment_date': instance.paymentDate?.toIso8601String(),
      'mass_grams': instance.massGrams,
      'brute_amount': instance.bruteAmount,
      'commission': instance.commission,
      'net_amount': instance.netAmount,
    };
