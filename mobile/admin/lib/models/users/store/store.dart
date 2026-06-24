import 'package:diakron_admin/models/core/validation_status/validation_status.dart';
import 'package:diakron_admin/models/users/user_base/user_base.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
abstract class Store with _$Store implements UserBase {
  // Private constructor to enable getters and methods in Freezed model
  const Store._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Store({

    @JsonKey(includeToJson: false) required String? email,
    // Validation status
    @Default(ValidationStatus.uploading) String? validationStatus,
    // UserBase fields
    required String? id,
    required String? userName,
    required String? surnames,
    required String? phoneNumber,
    required bool? isActive,
    required String? userType,
    required DateTime? createdAt,

    // Store fields
    String? companyName,
    String? commercialName,
    String? rfc,
    String? taxRegime,
    String? taxpayerType,
    String? address,
    String? category,
    String? bank,
    String? clabe,
    String? billingEmail,
    String? postCode,
    Map<String, dynamic>? schedule,

    // Document Paths
    String? pathLogo,
    String? pathIdRep,
    String? pathProofAddress,
    String? pathTaxCertificate,

    // This properties ared needed for store, but not manually stored in DB
    @Default(0) @JsonKey(includeToJson: false) int pointsExchanged,
    @Default(0) @JsonKey(includeToJson: false) int firstExchangesParticipant,

    
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);

  String get urlLogo =>
      '${dotenv.get('SUPABASE_URL')}/storage/v1/object/public/diakron_storage_public/$pathLogo';
}
