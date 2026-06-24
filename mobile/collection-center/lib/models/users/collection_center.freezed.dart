// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_center.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollectionCenter {

// Validation status
 String? get validationStatus;// UserBase fields
 String? get email; String? get id; String? get userName; String? get surnames; String? get phoneNumber; bool? get isActive; String? get userType; DateTime? get createdAt;// Legal representative    
 String? get curpRep;// CollectionCenter fields
 String? get companyName; String? get commercialName; String? get rfc; String? get taxRegime; String? get taxpayerType; String? get address; String? get bank; String? get clabe; String? get billingEmail; String? get postCode; String? get taxAddress; Map<String, dynamic>? get schedule;// Document Paths   
// String? pathLogo,
 String? get pathIdRep; String? get pathProofAddress; String? get pathTaxCertificate;
/// Create a copy of CollectionCenter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionCenterCopyWith<CollectionCenter> get copyWith => _$CollectionCenterCopyWithImpl<CollectionCenter>(this as CollectionCenter, _$identity);

  /// Serializes this CollectionCenter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionCenter&&(identical(other.validationStatus, validationStatus) || other.validationStatus == validationStatus)&&(identical(other.email, email) || other.email == email)&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.curpRep, curpRep) || other.curpRep == curpRep)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.commercialName, commercialName) || other.commercialName == commercialName)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.taxRegime, taxRegime) || other.taxRegime == taxRegime)&&(identical(other.taxpayerType, taxpayerType) || other.taxpayerType == taxpayerType)&&(identical(other.address, address) || other.address == address)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.clabe, clabe) || other.clabe == clabe)&&(identical(other.billingEmail, billingEmail) || other.billingEmail == billingEmail)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&(identical(other.taxAddress, taxAddress) || other.taxAddress == taxAddress)&&const DeepCollectionEquality().equals(other.schedule, schedule)&&(identical(other.pathIdRep, pathIdRep) || other.pathIdRep == pathIdRep)&&(identical(other.pathProofAddress, pathProofAddress) || other.pathProofAddress == pathProofAddress)&&(identical(other.pathTaxCertificate, pathTaxCertificate) || other.pathTaxCertificate == pathTaxCertificate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,validationStatus,email,id,userName,surnames,phoneNumber,isActive,userType,createdAt,curpRep,companyName,commercialName,rfc,taxRegime,taxpayerType,address,bank,clabe,billingEmail,postCode,taxAddress,const DeepCollectionEquality().hash(schedule),pathIdRep,pathProofAddress,pathTaxCertificate]);

@override
String toString() {
  return 'CollectionCenter(validationStatus: $validationStatus, email: $email, id: $id, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, curpRep: $curpRep, companyName: $companyName, commercialName: $commercialName, rfc: $rfc, taxRegime: $taxRegime, taxpayerType: $taxpayerType, address: $address, bank: $bank, clabe: $clabe, billingEmail: $billingEmail, postCode: $postCode, taxAddress: $taxAddress, schedule: $schedule, pathIdRep: $pathIdRep, pathProofAddress: $pathProofAddress, pathTaxCertificate: $pathTaxCertificate)';
}


}

/// @nodoc
abstract mixin class $CollectionCenterCopyWith<$Res>  {
  factory $CollectionCenterCopyWith(CollectionCenter value, $Res Function(CollectionCenter) _then) = _$CollectionCenterCopyWithImpl;
@useResult
$Res call({
 String? validationStatus, String? email, String? id, String? userName, String? surnames, String? phoneNumber, bool? isActive, String? userType, DateTime? createdAt, String? curpRep, String? companyName, String? commercialName, String? rfc, String? taxRegime, String? taxpayerType, String? address, String? bank, String? clabe, String? billingEmail, String? postCode, String? taxAddress, Map<String, dynamic>? schedule, String? pathIdRep, String? pathProofAddress, String? pathTaxCertificate
});




}
/// @nodoc
class _$CollectionCenterCopyWithImpl<$Res>
    implements $CollectionCenterCopyWith<$Res> {
  _$CollectionCenterCopyWithImpl(this._self, this._then);

  final CollectionCenter _self;
  final $Res Function(CollectionCenter) _then;

/// Create a copy of CollectionCenter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? validationStatus = freezed,Object? email = freezed,Object? id = freezed,Object? userName = freezed,Object? surnames = freezed,Object? phoneNumber = freezed,Object? isActive = freezed,Object? userType = freezed,Object? createdAt = freezed,Object? curpRep = freezed,Object? companyName = freezed,Object? commercialName = freezed,Object? rfc = freezed,Object? taxRegime = freezed,Object? taxpayerType = freezed,Object? address = freezed,Object? bank = freezed,Object? clabe = freezed,Object? billingEmail = freezed,Object? postCode = freezed,Object? taxAddress = freezed,Object? schedule = freezed,Object? pathIdRep = freezed,Object? pathProofAddress = freezed,Object? pathTaxCertificate = freezed,}) {
  return _then(_self.copyWith(
validationStatus: freezed == validationStatus ? _self.validationStatus : validationStatus // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,surnames: freezed == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,curpRep: freezed == curpRep ? _self.curpRep : curpRep // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,commercialName: freezed == commercialName ? _self.commercialName : commercialName // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,taxRegime: freezed == taxRegime ? _self.taxRegime : taxRegime // ignore: cast_nullable_to_non_nullable
as String?,taxpayerType: freezed == taxpayerType ? _self.taxpayerType : taxpayerType // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as String?,clabe: freezed == clabe ? _self.clabe : clabe // ignore: cast_nullable_to_non_nullable
as String?,billingEmail: freezed == billingEmail ? _self.billingEmail : billingEmail // ignore: cast_nullable_to_non_nullable
as String?,postCode: freezed == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String?,taxAddress: freezed == taxAddress ? _self.taxAddress : taxAddress // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,pathIdRep: freezed == pathIdRep ? _self.pathIdRep : pathIdRep // ignore: cast_nullable_to_non_nullable
as String?,pathProofAddress: freezed == pathProofAddress ? _self.pathProofAddress : pathProofAddress // ignore: cast_nullable_to_non_nullable
as String?,pathTaxCertificate: freezed == pathTaxCertificate ? _self.pathTaxCertificate : pathTaxCertificate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectionCenter].
extension CollectionCenterPatterns on CollectionCenter {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollectionCenter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollectionCenter() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollectionCenter value)  $default,){
final _that = this;
switch (_that) {
case _CollectionCenter():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollectionCenter value)?  $default,){
final _that = this;
switch (_that) {
case _CollectionCenter() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? validationStatus,  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? curpRep,  String? companyName,  String? commercialName,  String? rfc,  String? taxRegime,  String? taxpayerType,  String? address,  String? bank,  String? clabe,  String? billingEmail,  String? postCode,  String? taxAddress,  Map<String, dynamic>? schedule,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionCenter() when $default != null:
return $default(_that.validationStatus,_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.curpRep,_that.companyName,_that.commercialName,_that.rfc,_that.taxRegime,_that.taxpayerType,_that.address,_that.bank,_that.clabe,_that.billingEmail,_that.postCode,_that.taxAddress,_that.schedule,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? validationStatus,  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? curpRep,  String? companyName,  String? commercialName,  String? rfc,  String? taxRegime,  String? taxpayerType,  String? address,  String? bank,  String? clabe,  String? billingEmail,  String? postCode,  String? taxAddress,  Map<String, dynamic>? schedule,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate)  $default,) {final _that = this;
switch (_that) {
case _CollectionCenter():
return $default(_that.validationStatus,_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.curpRep,_that.companyName,_that.commercialName,_that.rfc,_that.taxRegime,_that.taxpayerType,_that.address,_that.bank,_that.clabe,_that.billingEmail,_that.postCode,_that.taxAddress,_that.schedule,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? validationStatus,  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? curpRep,  String? companyName,  String? commercialName,  String? rfc,  String? taxRegime,  String? taxpayerType,  String? address,  String? bank,  String? clabe,  String? billingEmail,  String? postCode,  String? taxAddress,  Map<String, dynamic>? schedule,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate)?  $default,) {final _that = this;
switch (_that) {
case _CollectionCenter() when $default != null:
return $default(_that.validationStatus,_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.curpRep,_that.companyName,_that.commercialName,_that.rfc,_that.taxRegime,_that.taxpayerType,_that.address,_that.bank,_that.clabe,_that.billingEmail,_that.postCode,_that.taxAddress,_that.schedule,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CollectionCenter extends CollectionCenter {
  const _CollectionCenter({this.validationStatus = ValidationStatus.uploading, required this.email, required this.id, required this.userName, required this.surnames, required this.phoneNumber, required this.isActive, required this.userType, required this.createdAt, this.curpRep, this.companyName, this.commercialName, this.rfc, this.taxRegime, this.taxpayerType, this.address, this.bank, this.clabe, this.billingEmail, this.postCode, this.taxAddress, final  Map<String, dynamic>? schedule, this.pathIdRep, this.pathProofAddress, this.pathTaxCertificate}): _schedule = schedule,super._();
  factory _CollectionCenter.fromJson(Map<String, dynamic> json) => _$CollectionCenterFromJson(json);

// Validation status
@override@JsonKey() final  String? validationStatus;
// UserBase fields
@override final  String? email;
@override final  String? id;
@override final  String? userName;
@override final  String? surnames;
@override final  String? phoneNumber;
@override final  bool? isActive;
@override final  String? userType;
@override final  DateTime? createdAt;
// Legal representative    
@override final  String? curpRep;
// CollectionCenter fields
@override final  String? companyName;
@override final  String? commercialName;
@override final  String? rfc;
@override final  String? taxRegime;
@override final  String? taxpayerType;
@override final  String? address;
@override final  String? bank;
@override final  String? clabe;
@override final  String? billingEmail;
@override final  String? postCode;
@override final  String? taxAddress;
 final  Map<String, dynamic>? _schedule;
@override Map<String, dynamic>? get schedule {
  final value = _schedule;
  if (value == null) return null;
  if (_schedule is EqualUnmodifiableMapView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Document Paths   
// String? pathLogo,
@override final  String? pathIdRep;
@override final  String? pathProofAddress;
@override final  String? pathTaxCertificate;

/// Create a copy of CollectionCenter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionCenterCopyWith<_CollectionCenter> get copyWith => __$CollectionCenterCopyWithImpl<_CollectionCenter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionCenterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionCenter&&(identical(other.validationStatus, validationStatus) || other.validationStatus == validationStatus)&&(identical(other.email, email) || other.email == email)&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.curpRep, curpRep) || other.curpRep == curpRep)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.commercialName, commercialName) || other.commercialName == commercialName)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.taxRegime, taxRegime) || other.taxRegime == taxRegime)&&(identical(other.taxpayerType, taxpayerType) || other.taxpayerType == taxpayerType)&&(identical(other.address, address) || other.address == address)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.clabe, clabe) || other.clabe == clabe)&&(identical(other.billingEmail, billingEmail) || other.billingEmail == billingEmail)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&(identical(other.taxAddress, taxAddress) || other.taxAddress == taxAddress)&&const DeepCollectionEquality().equals(other._schedule, _schedule)&&(identical(other.pathIdRep, pathIdRep) || other.pathIdRep == pathIdRep)&&(identical(other.pathProofAddress, pathProofAddress) || other.pathProofAddress == pathProofAddress)&&(identical(other.pathTaxCertificate, pathTaxCertificate) || other.pathTaxCertificate == pathTaxCertificate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,validationStatus,email,id,userName,surnames,phoneNumber,isActive,userType,createdAt,curpRep,companyName,commercialName,rfc,taxRegime,taxpayerType,address,bank,clabe,billingEmail,postCode,taxAddress,const DeepCollectionEquality().hash(_schedule),pathIdRep,pathProofAddress,pathTaxCertificate]);

@override
String toString() {
  return 'CollectionCenter(validationStatus: $validationStatus, email: $email, id: $id, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, curpRep: $curpRep, companyName: $companyName, commercialName: $commercialName, rfc: $rfc, taxRegime: $taxRegime, taxpayerType: $taxpayerType, address: $address, bank: $bank, clabe: $clabe, billingEmail: $billingEmail, postCode: $postCode, taxAddress: $taxAddress, schedule: $schedule, pathIdRep: $pathIdRep, pathProofAddress: $pathProofAddress, pathTaxCertificate: $pathTaxCertificate)';
}


}

/// @nodoc
abstract mixin class _$CollectionCenterCopyWith<$Res> implements $CollectionCenterCopyWith<$Res> {
  factory _$CollectionCenterCopyWith(_CollectionCenter value, $Res Function(_CollectionCenter) _then) = __$CollectionCenterCopyWithImpl;
@override @useResult
$Res call({
 String? validationStatus, String? email, String? id, String? userName, String? surnames, String? phoneNumber, bool? isActive, String? userType, DateTime? createdAt, String? curpRep, String? companyName, String? commercialName, String? rfc, String? taxRegime, String? taxpayerType, String? address, String? bank, String? clabe, String? billingEmail, String? postCode, String? taxAddress, Map<String, dynamic>? schedule, String? pathIdRep, String? pathProofAddress, String? pathTaxCertificate
});




}
/// @nodoc
class __$CollectionCenterCopyWithImpl<$Res>
    implements _$CollectionCenterCopyWith<$Res> {
  __$CollectionCenterCopyWithImpl(this._self, this._then);

  final _CollectionCenter _self;
  final $Res Function(_CollectionCenter) _then;

/// Create a copy of CollectionCenter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? validationStatus = freezed,Object? email = freezed,Object? id = freezed,Object? userName = freezed,Object? surnames = freezed,Object? phoneNumber = freezed,Object? isActive = freezed,Object? userType = freezed,Object? createdAt = freezed,Object? curpRep = freezed,Object? companyName = freezed,Object? commercialName = freezed,Object? rfc = freezed,Object? taxRegime = freezed,Object? taxpayerType = freezed,Object? address = freezed,Object? bank = freezed,Object? clabe = freezed,Object? billingEmail = freezed,Object? postCode = freezed,Object? taxAddress = freezed,Object? schedule = freezed,Object? pathIdRep = freezed,Object? pathProofAddress = freezed,Object? pathTaxCertificate = freezed,}) {
  return _then(_CollectionCenter(
validationStatus: freezed == validationStatus ? _self.validationStatus : validationStatus // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,surnames: freezed == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,curpRep: freezed == curpRep ? _self.curpRep : curpRep // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,commercialName: freezed == commercialName ? _self.commercialName : commercialName // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,taxRegime: freezed == taxRegime ? _self.taxRegime : taxRegime // ignore: cast_nullable_to_non_nullable
as String?,taxpayerType: freezed == taxpayerType ? _self.taxpayerType : taxpayerType // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as String?,clabe: freezed == clabe ? _self.clabe : clabe // ignore: cast_nullable_to_non_nullable
as String?,billingEmail: freezed == billingEmail ? _self.billingEmail : billingEmail // ignore: cast_nullable_to_non_nullable
as String?,postCode: freezed == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String?,taxAddress: freezed == taxAddress ? _self.taxAddress : taxAddress // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,pathIdRep: freezed == pathIdRep ? _self.pathIdRep : pathIdRep // ignore: cast_nullable_to_non_nullable
as String?,pathProofAddress: freezed == pathProofAddress ? _self.pathProofAddress : pathProofAddress // ignore: cast_nullable_to_non_nullable
as String?,pathTaxCertificate: freezed == pathTaxCertificate ? _self.pathTaxCertificate : pathTaxCertificate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
