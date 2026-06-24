// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WasteCollection _$WasteCollectionFromJson(Map<String, dynamic> json) =>
    _WasteCollection(
      id: (json['id'] as num).toInt(),
      idCollector: json['id_collector'] as String,
      idWasteType: (json['id_waste_type'] as num).toInt(),
      idSegregator: (json['id_segregator'] as num).toInt(),
      collDate: DateTime.parse(json['coll_date'] as String),
      isComplete: json['is_complete'] as bool,
      idCollectionCenter: json['id_collection_center'] as String?,
      paymentDate: json['payment_date'] == null
          ? null
          : DateTime.parse(json['payment_date'] as String),
      massGrams: (json['mass_grams'] as num?)?.toInt(),
      bruteAmount: (json['brute_amount'] as num?)?.toDouble(),
      commission: (json['commission'] as num?)?.toDouble(),
      netAmount: (json['net_amount'] as num?)?.toDouble(),
      ccenterName: json['ccenter_name'] as String?,
      collectorName: json['collector_name'] as String?,
      collectorSurnames: json['collector_surnames'] as String?,
      ccenterAddress: json['ccenter_address'] as String?,
    );

Map<String, dynamic> _$WasteCollectionToJson(_WasteCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_collector': instance.idCollector,
      'id_waste_type': instance.idWasteType,
      'id_segregator': instance.idSegregator,
      'coll_date': instance.collDate.toIso8601String(),
      'is_complete': instance.isComplete,
      'id_collection_center': instance.idCollectionCenter,
      'payment_date': instance.paymentDate?.toIso8601String(),
      'mass_grams': instance.massGrams,
      'brute_amount': instance.bruteAmount,
      'commission': instance.commission,
      'net_amount': instance.netAmount,
      'ccenter_name': instance.ccenterName,
      'collector_name': instance.collectorName,
      'collector_surnames': instance.collectorSurnames,
      'ccenter_address': instance.ccenterAddress,
    };
