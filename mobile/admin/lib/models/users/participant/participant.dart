import 'package:diakron_admin/models/users/user_base/user_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

@freezed
abstract class Participant with _$Participant implements UserBase {

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Participant({
    // Validation status
    
    @JsonKey(includeToJson: false) required String? email,
    // UserBase fields
    required String id,
    required String? userName,
    required String? surnames,
    required String? phoneNumber,
    required bool? isActive,
    required String? userType,
    required DateTime? createdAt,

    // Participant fields
    required int points,

    // Needed for participant, not manually stored
    @JsonKey(includeToJson: false) String? phrase,

  }) = _Participant;

  factory Participant.fromJson(Map<String, Object?> json) =>
      _$ParticipantFromJson(json);
}