// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_center.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectionCenter _$CollectionCenterFromJson(Map<String, dynamic> json) =>
    _CollectionCenter(
      validationStatus:
          json['validation_status'] as String? ?? ValidationStatus.uploading,
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
      curpRep: json['curp_rep'] as String?,
      companyName: json['company_name'] as String?,
      commercialName: json['commercial_name'] as String?,
      rfc: json['rfc'] as String?,
      taxRegime: json['tax_regime'] as String?,
      taxpayerType: json['taxpayer_type'] as String?,
      address: json['address'] as String?,
      bank: json['bank'] as String?,
      clabe: json['clabe'] as String?,
      billingEmail: json['billing_email'] as String?,
      postCode: json['post_code'] as String?,
      taxAddress: json['tax_address'] as String?,
      schedule: json['schedule'] as Map<String, dynamic>?,
      pathIdRep: json['path_id_rep'] as String?,
      pathProofAddress: json['path_proof_address'] as String?,
      pathTaxCertificate: json['path_tax_certificate'] as String?,
    );

Map<String, dynamic> _$CollectionCenterToJson(_CollectionCenter instance) =>
    <String, dynamic>{
      'validation_status': instance.validationStatus,
      'email': instance.email,
      'id': instance.id,
      'user_name': instance.userName,
      'surnames': instance.surnames,
      'phone_number': instance.phoneNumber,
      'is_active': instance.isActive,
      'user_type': instance.userType,
      'created_at': instance.createdAt?.toIso8601String(),
      'curp_rep': instance.curpRep,
      'company_name': instance.companyName,
      'commercial_name': instance.commercialName,
      'rfc': instance.rfc,
      'tax_regime': instance.taxRegime,
      'taxpayer_type': instance.taxpayerType,
      'address': instance.address,
      'bank': instance.bank,
      'clabe': instance.clabe,
      'billing_email': instance.billingEmail,
      'post_code': instance.postCode,
      'tax_address': instance.taxAddress,
      'schedule': instance.schedule,
      'path_id_rep': instance.pathIdRep,
      'path_proof_address': instance.pathProofAddress,
      'path_tax_certificate': instance.pathTaxCertificate,
    };
