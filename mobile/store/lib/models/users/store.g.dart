// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Store _$StoreFromJson(Map<String, dynamic> json) => _Store(
  email: json['email'] as String?,
  validationStatus:
      json['validation_status'] as String? ?? ValidationStatus.uploading,
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
  commercialName: json['commercial_name'] as String?,
  rfc: json['rfc'] as String?,
  taxRegime: json['tax_regime'] as String?,
  taxpayerType: json['taxpayer_type'] as String?,
  address: json['address'] as String?,
  category: json['category'] as String?,
  bank: json['bank'] as String?,
  clabe: json['clabe'] as String?,
  billingEmail: json['billing_email'] as String?,
  postCode: json['post_code'] as String?,
  schedule: json['schedule'] as Map<String, dynamic>?,
  pathLogo: json['path_logo'] as String?,
  pathIdRep: json['path_id_rep'] as String?,
  pathProofAddress: json['path_proof_address'] as String?,
  pathTaxCertificate: json['path_tax_certificate'] as String?,
  mpAccessToken: json['mp_access_token'] as String?,
  pointsExchanged: (json['points_exchanged'] as num?)?.toInt() ?? 0,
  firstExchangesParticipant:
      (json['first_exchanges_participant'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$StoreToJson(_Store instance) => <String, dynamic>{
  'validation_status': instance.validationStatus,
  'id': instance.id,
  'user_name': instance.userName,
  'surnames': instance.surnames,
  'phone_number': instance.phoneNumber,
  'is_active': instance.isActive,
  'user_type': instance.userType,
  'created_at': instance.createdAt?.toIso8601String(),
  'company_name': instance.companyName,
  'commercial_name': instance.commercialName,
  'rfc': instance.rfc,
  'tax_regime': instance.taxRegime,
  'taxpayer_type': instance.taxpayerType,
  'address': instance.address,
  'category': instance.category,
  'bank': instance.bank,
  'clabe': instance.clabe,
  'billing_email': instance.billingEmail,
  'post_code': instance.postCode,
  'schedule': instance.schedule,
  'path_logo': instance.pathLogo,
  'path_id_rep': instance.pathIdRep,
  'path_proof_address': instance.pathProofAddress,
  'path_tax_certificate': instance.pathTaxCertificate,
};
