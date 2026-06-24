import 'package:diakron_admin/models/users/user_base/user_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin.freezed.dart';
part 'admin.g.dart';

@freezed
abstract class Admin with _$Admin implements UserBase {

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Admin({
    
    @JsonKey(includeToJson: false) required String? email,
    // UserBase fields
    required String? id,
    required String? userName,
    required String? surnames,
    required String? phoneNumber,
    required bool? isActive,
    required String? userType,

    required DateTime? createdAt,
    required bool? isSuperadmin,

  }) = _Admin;

  factory Admin.fromJson(Map<String, Object?> json) =>
      _$AdminFromJson(json);
}