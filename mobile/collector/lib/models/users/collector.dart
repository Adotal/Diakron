import 'package:diakron_collectors/models/users/user_base/user_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collector.freezed.dart';
part 'collector.g.dart';

@freezed
abstract class Collector with _$Collector implements UserBase {

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Collector({
    // Validation status
    // UserBase fields
    required String id,
    required String email,
    required String userName,
    required String surnames,
    required String phoneNumber,
    required bool isActive,
    required String userType,
    required DateTime createdAt,
    String? mpAccessToken,

  }) = _Collector;

  factory Collector.fromJson(Map<String, Object?> json) =>
      _$CollectorFromJson(json);
}