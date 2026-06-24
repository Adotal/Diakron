import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_waste_stats.freezed.dart';
part 'user_waste_stats.g.dart';

@freezed
abstract class UserWasteStats with _$UserWasteStats {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserWasteStats({
    required int countMetal,
    required int weightMetal,
    required int countPlastic,
    required int weightPlastic,
    required int countGlass,
    required int weightGlass,
    required int countPaper,
    required int weightPaper,
  }) = _UserWasteStats;

  factory UserWasteStats.fromJson(Map<String, dynamic> json) =>
      _$UserWasteStatsFromJson(json);

  // Private constructor to enable personalized methods in Freezed model
  const UserWasteStats._();

  // Energy saves in kWh
  double get metalEnergy => countMetal * 2.1375;
  double get glassEnergy => countGlass * 0.30;
  double get plasticEnergy => countPlastic * 0.375;
  double get paperEnergy => countPaper * 0.025;

  bool get isEmpty {
    return (countMetal == 0 &&
        countPlastic == 0 &&
        countGlass == 0 &&
        countPaper == 0);
  }
}
