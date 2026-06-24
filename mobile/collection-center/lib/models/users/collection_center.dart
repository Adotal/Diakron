import 'package:diakron_collection_center/models/core/validation_status/validation_status.dart';
import 'package:diakron_collection_center/models/users/user_base/user_base.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_center.freezed.dart';
part 'collection_center.g.dart';

@freezed
abstract class CollectionCenter with _$CollectionCenter implements UserBase {

  // Private constructor to enable getters and methods in Freezed model
  const CollectionCenter._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CollectionCenter({
    // Validation status
    @Default(ValidationStatus.uploading) String? validationStatus,
    // UserBase fields
    required String? email,

    required String? id,
    required String? userName,
    required String? surnames,
    required String? phoneNumber,
    required bool? isActive,
    required String? userType,
    required DateTime? createdAt,

    // Legal representative    
    String? curpRep,
  
    // CollectionCenter fields
    String? companyName,
    String? commercialName,
    String? rfc,
    String? taxRegime,
    String? taxpayerType,    
    String? address,
    String? bank,
    String? clabe,
    String? billingEmail,
    String? postCode,
    String? taxAddress,
    Map<String, dynamic>? schedule,

    // Document Paths   
    // String? pathLogo,
    String? pathIdRep,   
    String? pathProofAddress,
    String? pathTaxCertificate,

  }) = _CollectionCenter;

  factory CollectionCenter.fromJson(Map<String, Object?> json) =>
      _$CollectionCenterFromJson(json);

  // String get urlLogo => '${dotenv.get('SUPABASE_URL')}/storage/v1/object/public/diakron_storage_public/$pathLogo';
}