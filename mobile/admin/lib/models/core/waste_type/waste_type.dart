import 'package:freezed_annotation/freezed_annotation.dart';

part 'waste_type.freezed.dart';
part 'waste_type.g.dart';

@freezed
abstract class WasteType with _$WasteType{
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WasteType({
        
    required int id,
    required String? wasteType,

  }) = _WasteType;

  factory WasteType.fromJson(Map<String, Object?> json) =>
      _$WasteTypeFromJson(json);
}
