// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BinModel _$BinModelFromJson(Map<String, dynamic> json) => _BinModel(
  id: (json['id'] as num).toInt(),
  idWasteType: (json['id_waste_type'] as num).toInt(),
  wasteType: json['waste_type'] as String,
  lastDate: DateTime.parse(json['last_date'] as String),
  totalMass: (json['total_mass'] as num?)?.toInt(),
  fillingPercentage: (json['filling_percentage'] as num).toInt(),
);

Map<String, dynamic> _$BinModelToJson(_BinModel instance) => <String, dynamic>{
  'id': instance.id,
  'id_waste_type': instance.idWasteType,
  'waste_type': instance.wasteType,
  'last_date': instance.lastDate.toIso8601String(),
  'total_mass': instance.totalMass,
  'filling_percentage': instance.fillingPercentage,
};
