import 'package:freezed_annotation/freezed_annotation.dart';

part 'incentive.freezed.dart';
part 'incentive.g.dart';

@freezed
abstract class Incentive with _$Incentive {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Incentive({

    required int id,
    required String idStore,
    required int amount,
    required double repPercentage,
    required DateTime createdAt,
    required String storeCommercialName,
    required int storePointsExchanged,

  }) = _Incentive;

  factory Incentive.fromJson(Map<String, dynamic> json) =>
      _$IncentiveFromJson(json);

}
