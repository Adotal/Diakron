import 'package:freezed_annotation/freezed_annotation.dart';

part 'bin_model.freezed.dart';
part 'bin_model.g.dart';

@freezed
abstract class BinModel with _$BinModel {

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BinModel({
    required int id,
    required int idWasteType,
    required String wasteType,
    required DateTime lastDate,
    int? totalMass,
    required int fillingPercentage,
  }) = _BinModel;

  factory BinModel.fromJson(Map<String, dynamic> json) => _$BinModelFromJson(json);
}