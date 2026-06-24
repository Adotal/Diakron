// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_center.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectionCenter _$CollectionCenterFromJson(Map<String, dynamic> json) =>
    _CollectionCenter(
      email: json['email'] as String?,
      id: json['id'] as String?,
      userName: json['user_name'] as String?,
      surnames: json['surnames'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isActive: json['is_active'] as bool?,
      userType: json['user_type'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      companyName: json['company_name'] as String?,
      rfc: json['rfc'] as String?,
      taxRegime: json['tax_regime'] as String?,
      curpRep: json['curp_rep'] as String?,
      bank: json['bank'] as String?,
      clabe: json['clabe'] as String?,
      commercialName: json['commercial_name'] as String?,
      address: json['address'] as String?,
      billingEmail: json['billing_email'] as String?,
      taxpayerType: json['taxpayer_type'] as String?,
      postCode: json['post_code'] as String?,
      schedule: json['schedule'] as Map<String, dynamic>?,
      pathIdRep: json['path_id_rep'] as String?,
      pathProofAddress: json['path_proof_address'] as String?,
      pathTaxCertificate: json['path_tax_certificate'] as String?,
      validationStatus:
          json['validation_status'] as String? ?? ValidationStatus.uploading,
      wasteTypeIds:
          (json['waste_type_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CollectionCenterToJson(_CollectionCenter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'surnames': instance.surnames,
      'phone_number': instance.phoneNumber,
      'is_active': instance.isActive,
      'user_type': instance.userType,
      'created_at': instance.createdAt?.toIso8601String(),
      'company_name': instance.companyName,
      'rfc': instance.rfc,
      'tax_regime': instance.taxRegime,
      'curp_rep': instance.curpRep,
      'bank': instance.bank,
      'clabe': instance.clabe,
      'commercial_name': instance.commercialName,
      'address': instance.address,
      'billing_email': instance.billingEmail,
      'taxpayer_type': instance.taxpayerType,
      'post_code': instance.postCode,
      'schedule': instance.schedule,
      'path_id_rep': instance.pathIdRep,
      'path_proof_address': instance.pathProofAddress,
      'path_tax_certificate': instance.pathTaxCertificate,
      'validation_status': instance.validationStatus,
    };
