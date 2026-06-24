import 'package:freezed_annotation/freezed_annotation.dart';

part 'incentive.freezed.dart';
part 'incentive.g.dart';

@freezed
abstract class Incentive with _$Incentive {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Incentive({
    required int? id,
    required String idStore,
    required int amount,
    required int repPercentage,
    required DateTime createdAt
  }) = _Incentive;

  factory Incentive.fromJson(Map<String, Object?> json) => _$IncentiveFromJson(json);
}
