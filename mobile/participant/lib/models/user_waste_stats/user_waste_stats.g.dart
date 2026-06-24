// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_waste_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserWasteStats _$UserWasteStatsFromJson(Map<String, dynamic> json) =>
    _UserWasteStats(
      countMetal: (json['count_metal'] as num).toInt(),
      weightMetal: (json['weight_metal'] as num).toInt(),
      countPlastic: (json['count_plastic'] as num).toInt(),
      weightPlastic: (json['weight_plastic'] as num).toInt(),
      countGlass: (json['count_glass'] as num).toInt(),
      weightGlass: (json['weight_glass'] as num).toInt(),
      countPaper: (json['count_paper'] as num).toInt(),
      weightPaper: (json['weight_paper'] as num).toInt(),
    );

Map<String, dynamic> _$UserWasteStatsToJson(_UserWasteStats instance) =>
    <String, dynamic>{
      'count_metal': instance.countMetal,
      'weight_metal': instance.weightMetal,
      'count_plastic': instance.countPlastic,
      'weight_plastic': instance.weightPlastic,
      'count_glass': instance.countGlass,
      'weight_glass': instance.weightGlass,
      'count_paper': instance.countPaper,
      'weight_paper': instance.weightPaper,
    };
