import 'package:diakron_admin/models/users/user_base/user_base.dart';
import 'package:diakron_admin/models/core/validation_status/validation_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_center.freezed.dart';
part 'collection_center.g.dart';

@freezed
abstract class CollectionCenter with _$CollectionCenter implements UserBase {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CollectionCenter({
    
    // Email is a property of supabase auth, shouldn't be modified
    @JsonKey(includeToJson: false) 
    required String? email,

    // UserBase fields
    required String? id,    
    required String? userName,
    required String? surnames,
    required String? phoneNumber,
    required bool? isActive,
    required String? userType,
    required DateTime? createdAt,

    // Collection center fields
    String? companyName,
    String? rfc,
    String? taxRegime,
    String? curpRep,
    String? bank,
    String? clabe,
    String? commercialName,
    String? address,
    String? billingEmail,
    String? taxpayerType,
    String? postCode,
    Map<String, dynamic>? schedule,

    // Document Paths
    String? pathIdRep,
    String? pathProofAddress,
    String? pathTaxCertificate,

    // Validation status
    @Default(ValidationStatus.uploading) String? validationStatus,

    // WasteTypes
    @Default([]) @JsonKey(includeToJson: false) List<int> wasteTypeIds,
    
  }) = _CollectionCenter;

  // @override
  factory CollectionCenter.fromJson(Map<String, Object?> json) =>
      _$CollectionCenterFromJson(json);
}
