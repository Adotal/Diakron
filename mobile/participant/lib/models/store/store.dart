import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
abstract class Store with _$Store /* implements UserBase*/ {
  // Private constructor to enable getters and methods in Freezed model
  const Store._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Store({
    // Validation status
    // @Default(ValidationStatus.uploading) String? validationStatus,
    // UserBase fields
    required String id,
    // required String? userName,
    // required String? surnames,
    // required String? phoneNumber,
    // required bool? isActive,
    // required String? userType,
    // required DateTime? createdAt,

    // Store fields
    // String? companyName,
    required String commercialName,
    // String? rfc,
    // String? taxRegime,
    // String? taxpayerType,
    required String address,
    required String category,
    // String? bank,
    // String? clabe,
    // String? billingEmail,
    
    required String postCode,
    required Map<String, dynamic> schedule,

    // Document Paths
    required String pathLogo,

    // String? pathIdRep,
    // String? pathProofAddress,
    // String? pathTaxCertificate,

    int? pointsExchanged,
  }) = _Store;

  factory Store.fromJson(Map<String, Object?> json) => _$StoreFromJson(json);

  String get urlLogo =>
      '${dotenv.get('SUPABASE_URL')}/storage/v1/object/public/diakron_storage_public/$pathLogo';
}
