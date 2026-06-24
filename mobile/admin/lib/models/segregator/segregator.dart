import 'package:diakron_admin/models/bin_model/bin_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'segregator.freezed.dart';
part 'segregator.g.dart';

@freezed
abstract class Segregator with _$Segregator {

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Segregator({
    required int id,
    required double? latitude,
    required double? longitude,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'payload_qr') String? payloadQr,
    required String? description,
    // Niveles de llenado
    required List<BinModel> bins,
    required DateTime? lastCollection,
  }) = _Segregator;

  factory Segregator.fromJson(Map<String, dynamic> json) => _$SegregatorFromJson(json);
}