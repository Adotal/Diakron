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

// Email is a property of supabase auth, shouldn't be modified
@JsonKey(includeToJson: false) String? get email;// UserBase fields
 String? get id; String? get userName; String? get surnames; String? get phoneNumber; bool? get isActive; String? get userType; DateTime? get createdAt;// Collection center fields
 String? get companyName; String? get rfc; String? get taxRegime; String? get curpRep; String? get bank; String? get clabe; String? get commercialName; String? get address; String? get billingEmail; String? get taxpayerType; String? get postCode; Map<String, dynamic>? get schedule;// Document Paths
 String? get pathIdRep; String? get pathProofAddress; String? get pathTaxCertificate;// Validation status
 String? get validationStatus;// WasteTypes
@JsonKey(includeToJson: false) List<int> get wasteTypeIds;
/// Create a copy of CollectionCenter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionCenterCopyWith<CollectionCenter> get copyWith => _$CollectionCenterCopyWithImpl<CollectionCenter>(this as CollectionCenter, _$identity);

  /// Serializes this CollectionCenter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectionCenter&&(identical(other.email, email) || other.email == email)&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.taxRegime, taxRegime) || other.taxRegime == taxRegime)&&(identical(other.curpRep, curpRep) || other.curpRep == curpRep)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.clabe, clabe) || other.clabe == clabe)&&(identical(other.commercialName, commercialName) || other.commercialName == commercialName)&&(identical(other.address, address) || other.address == address)&&(identical(other.billingEmail, billingEmail) || other.billingEmail == billingEmail)&&(identical(other.taxpayerType, taxpayerType) || other.taxpayerType == taxpayerType)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&const DeepCollectionEquality().equals(other.schedule, schedule)&&(identical(other.pathIdRep, pathIdRep) || other.pathIdRep == pathIdRep)&&(identical(other.pathProofAddress, pathProofAddress) || other.pathProofAddress == pathProofAddress)&&(identical(other.pathTaxCertificate, pathTaxCertificate) || other.pathTaxCertificate == pathTaxCertificate)&&(identical(other.validationStatus, validationStatus) || other.validationStatus == validationStatus)&&const DeepCollectionEquality().equals(other.wasteTypeIds, wasteTypeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,email,id,userName,surnames,phoneNumber,isActive,userType,createdAt,companyName,rfc,taxRegime,curpRep,bank,clabe,commercialName,address,billingEmail,taxpayerType,postCode,const DeepCollectionEquality().hash(schedule),pathIdRep,pathProofAddress,pathTaxCertificate,validationStatus,const DeepCollectionEquality().hash(wasteTypeIds)]);

@override
String toString() {
  return 'CollectionCenter(email: $email, id: $id, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, companyName: $companyName, rfc: $rfc, taxRegime: $taxRegime, curpRep: $curpRep, bank: $bank, clabe: $clabe, commercialName: $commercialName, address: $address, billingEmail: $billingEmail, taxpayerType: $taxpayerType, postCode: $postCode, schedule: $schedule, pathIdRep: $pathIdRep, pathProofAddress: $pathProofAddress, pathTaxCertificate: $pathTaxCertificate, validationStatus: $validationStatus, wasteTypeIds: $wasteTypeIds)';
}


}

/// @nodoc
abstract mixin class $CollectionCenterCopyWith<$Res>  {
  factory $CollectionCenterCopyWith(CollectionCenter value, $Res Function(CollectionCenter) _then) = _$CollectionCenterCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String? email, String? id, String? userName, String? surnames, String? phoneNumber, bool? isActive, String? userType, DateTime? createdAt, String? companyName, String? rfc, String? taxRegime, String? curpRep, String? bank, String? clabe, String? commercialName, String? address, String? billingEmail, String? taxpayerType, String? postCode, Map<String, dynamic>? schedule, String? pathIdRep, String? pathProofAddress, String? pathTaxCertificate, String? validationStatus,@JsonKey(includeToJson: false) List<int> wasteTypeIds
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
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? id = freezed,Object? userName = freezed,Object? surnames = freezed,Object? phoneNumber = freezed,Object? isActive = freezed,Object? userType = freezed,Object? createdAt = freezed,Object? companyName = freezed,Object? rfc = freezed,Object? taxRegime = freezed,Object? curpRep = freezed,Object? bank = freezed,Object? clabe = freezed,Object? commercialName = freezed,Object? address = freezed,Object? billingEmail = freezed,Object? taxpayerType = freezed,Object? postCode = freezed,Object? schedule = freezed,Object? pathIdRep = freezed,Object? pathProofAddress = freezed,Object? pathTaxCertificate = freezed,Object? validationStatus = freezed,Object? wasteTypeIds = null,}) {
  return _then(_self.copyWith(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,surnames: freezed == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,taxRegime: freezed == taxRegime ? _self.taxRegime : taxRegime // ignore: cast_nullable_to_non_nullable
as String?,curpRep: freezed == curpRep ? _self.curpRep : curpRep // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as String?,clabe: freezed == clabe ? _self.clabe : clabe // ignore: cast_nullable_to_non_nullable
as String?,commercialName: freezed == commercialName ? _self.commercialName : commercialName // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,billingEmail: freezed == billingEmail ? _self.billingEmail : billingEmail // ignore: cast_nullable_to_non_nullable
as String?,taxpayerType: freezed == taxpayerType ? _self.taxpayerType : taxpayerType // ignore: cast_nullable_to_non_nullable
as String?,postCode: freezed == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,pathIdRep: freezed == pathIdRep ? _self.pathIdRep : pathIdRep // ignore: cast_nullable_to_non_nullable
as String?,pathProofAddress: freezed == pathProofAddress ? _self.pathProofAddress : pathProofAddress // ignore: cast_nullable_to_non_nullable
as String?,pathTaxCertificate: freezed == pathTaxCertificate ? _self.pathTaxCertificate : pathTaxCertificate // ignore: cast_nullable_to_non_nullable
as String?,validationStatus: freezed == validationStatus ? _self.validationStatus : validationStatus // ignore: cast_nullable_to_non_nullable
as String?,wasteTypeIds: null == wasteTypeIds ? _self.wasteTypeIds : wasteTypeIds // ignore: cast_nullable_to_non_nullable
as List<int>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? companyName,  String? rfc,  String? taxRegime,  String? curpRep,  String? bank,  String? clabe,  String? commercialName,  String? address,  String? billingEmail,  String? taxpayerType,  String? postCode,  Map<String, dynamic>? schedule,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate,  String? validationStatus, @JsonKey(includeToJson: false)  List<int> wasteTypeIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollectionCenter() when $default != null:
return $default(_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.companyName,_that.rfc,_that.taxRegime,_that.curpRep,_that.bank,_that.clabe,_that.commercialName,_that.address,_that.billingEmail,_that.taxpayerType,_that.postCode,_that.schedule,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate,_that.validationStatus,_that.wasteTypeIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? companyName,  String? rfc,  String? taxRegime,  String? curpRep,  String? bank,  String? clabe,  String? commercialName,  String? address,  String? billingEmail,  String? taxpayerType,  String? postCode,  Map<String, dynamic>? schedule,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate,  String? validationStatus, @JsonKey(includeToJson: false)  List<int> wasteTypeIds)  $default,) {final _that = this;
switch (_that) {
case _CollectionCenter():
return $default(_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.companyName,_that.rfc,_that.taxRegime,_that.curpRep,_that.bank,_that.clabe,_that.commercialName,_that.address,_that.billingEmail,_that.taxpayerType,_that.postCode,_that.schedule,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate,_that.validationStatus,_that.wasteTypeIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? companyName,  String? rfc,  String? taxRegime,  String? curpRep,  String? bank,  String? clabe,  String? commercialName,  String? address,  String? billingEmail,  String? taxpayerType,  String? postCode,  Map<String, dynamic>? schedule,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate,  String? validationStatus, @JsonKey(includeToJson: false)  List<int> wasteTypeIds)?  $default,) {final _that = this;
switch (_that) {
case _CollectionCenter() when $default != null:
return $default(_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.companyName,_that.rfc,_that.taxRegime,_that.curpRep,_that.bank,_that.clabe,_that.commercialName,_that.address,_that.billingEmail,_that.taxpayerType,_that.postCode,_that.schedule,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate,_that.validationStatus,_that.wasteTypeIds);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CollectionCenter implements CollectionCenter {
  const _CollectionCenter({@JsonKey(includeToJson: false) required this.email, required this.id, required this.userName, required this.surnames, required this.phoneNumber, required this.isActive, required this.userType, required this.createdAt, this.companyName, this.rfc, this.taxRegime, this.curpRep, this.bank, this.clabe, this.commercialName, this.address, this.billingEmail, this.taxpayerType, this.postCode, final  Map<String, dynamic>? schedule, this.pathIdRep, this.pathProofAddress, this.pathTaxCertificate, this.validationStatus = ValidationStatus.uploading, @JsonKey(includeToJson: false) final  List<int> wasteTypeIds = const []}): _schedule = schedule,_wasteTypeIds = wasteTypeIds;
  factory _CollectionCenter.fromJson(Map<String, dynamic> json) => _$CollectionCenterFromJson(json);

// Email is a property of supabase auth, shouldn't be modified
@override@JsonKey(includeToJson: false) final  String? email;
// UserBase fields
@override final  String? id;
@override final  String? userName;
@override final  String? surnames;
@override final  String? phoneNumber;
@override final  bool? isActive;
@override final  String? userType;
@override final  DateTime? createdAt;
// Collection center fields
@override final  String? companyName;
@override final  String? rfc;
@override final  String? taxRegime;
@override final  String? curpRep;
@override final  String? bank;
@override final  String? clabe;
@override final  String? commercialName;
@override final  String? address;
@override final  String? billingEmail;
@override final  String? taxpayerType;
@override final  String? postCode;
 final  Map<String, dynamic>? _schedule;
@override Map<String, dynamic>? get schedule {
  final value = _schedule;
  if (value == null) return null;
  if (_schedule is EqualUnmodifiableMapView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Document Paths
@override final  String? pathIdRep;
@override final  String? pathProofAddress;
@override final  String? pathTaxCertificate;
// Validation status
@override@JsonKey() final  String? validationStatus;
// WasteTypes
 final  List<int> _wasteTypeIds;
// WasteTypes
@override@JsonKey(includeToJson: false) List<int> get wasteTypeIds {
  if (_wasteTypeIds is EqualUnmodifiableListView) return _wasteTypeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wasteTypeIds);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollectionCenter&&(identical(other.email, email) || other.email == email)&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.taxRegime, taxRegime) || other.taxRegime == taxRegime)&&(identical(other.curpRep, curpRep) || other.curpRep == curpRep)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.clabe, clabe) || other.clabe == clabe)&&(identical(other.commercialName, commercialName) || other.commercialName == commercialName)&&(identical(other.address, address) || other.address == address)&&(identical(other.billingEmail, billingEmail) || other.billingEmail == billingEmail)&&(identical(other.taxpayerType, taxpayerType) || other.taxpayerType == taxpayerType)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&const DeepCollectionEquality().equals(other._schedule, _schedule)&&(identical(other.pathIdRep, pathIdRep) || other.pathIdRep == pathIdRep)&&(identical(other.pathProofAddress, pathProofAddress) || other.pathProofAddress == pathProofAddress)&&(identical(other.pathTaxCertificate, pathTaxCertificate) || other.pathTaxCertificate == pathTaxCertificate)&&(identical(other.validationStatus, validationStatus) || other.validationStatus == validationStatus)&&const DeepCollectionEquality().equals(other._wasteTypeIds, _wasteTypeIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,email,id,userName,surnames,phoneNumber,isActive,userType,createdAt,companyName,rfc,taxRegime,curpRep,bank,clabe,commercialName,address,billingEmail,taxpayerType,postCode,const DeepCollectionEquality().hash(_schedule),pathIdRep,pathProofAddress,pathTaxCertificate,validationStatus,const DeepCollectionEquality().hash(_wasteTypeIds)]);

@override
String toString() {
  return 'CollectionCenter(email: $email, id: $id, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, companyName: $companyName, rfc: $rfc, taxRegime: $taxRegime, curpRep: $curpRep, bank: $bank, clabe: $clabe, commercialName: $commercialName, address: $address, billingEmail: $billingEmail, taxpayerType: $taxpayerType, postCode: $postCode, schedule: $schedule, pathIdRep: $pathIdRep, pathProofAddress: $pathProofAddress, pathTaxCertificate: $pathTaxCertificate, validationStatus: $validationStatus, wasteTypeIds: $wasteTypeIds)';
}


}

/// @nodoc
abstract mixin class _$CollectionCenterCopyWith<$Res> implements $CollectionCenterCopyWith<$Res> {
  factory _$CollectionCenterCopyWith(_CollectionCenter value, $Res Function(_CollectionCenter) _then) = __$CollectionCenterCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String? email, String? id, String? userName, String? surnames, String? phoneNumber, bool? isActive, String? userType, DateTime? createdAt, String? companyName, String? rfc, String? taxRegime, String? curpRep, String? bank, String? clabe, String? commercialName, String? address, String? billingEmail, String? taxpayerType, String? postCode, Map<String, dynamic>? schedule, String? pathIdRep, String? pathProofAddress, String? pathTaxCertificate, String? validationStatus,@JsonKey(includeToJson: false) List<int> wasteTypeIds
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
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? id = freezed,Object? userName = freezed,Object? surnames = freezed,Object? phoneNumber = freezed,Object? isActive = freezed,Object? userType = freezed,Object? createdAt = freezed,Object? companyName = freezed,Object? rfc = freezed,Object? taxRegime = freezed,Object? curpRep = freezed,Object? bank = freezed,Object? clabe = freezed,Object? commercialName = freezed,Object? address = freezed,Object? billingEmail = freezed,Object? taxpayerType = freezed,Object? postCode = freezed,Object? schedule = freezed,Object? pathIdRep = freezed,Object? pathProofAddress = freezed,Object? pathTaxCertificate = freezed,Object? validationStatus = freezed,Object? wasteTypeIds = null,}) {
  return _then(_CollectionCenter(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,surnames: freezed == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,taxRegime: freezed == taxRegime ? _self.taxRegime : taxRegime // ignore: cast_nullable_to_non_nullable
as String?,curpRep: freezed == curpRep ? _self.curpRep : curpRep // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as String?,clabe: freezed == clabe ? _self.clabe : clabe // ignore: cast_nullable_to_non_nullable
as String?,commercialName: freezed == commercialName ? _self.commercialName : commercialName // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,billingEmail: freezed == billingEmail ? _self.billingEmail : billingEmail // ignore: cast_nullable_to_non_nullable
as String?,taxpayerType: freezed == taxpayerType ? _self.taxpayerType : taxpayerType // ignore: cast_nullable_to_non_nullable
as String?,postCode: freezed == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,pathIdRep: freezed == pathIdRep ? _self.pathIdRep : pathIdRep // ignore: cast_nullable_to_non_nullable
as String?,pathProofAddress: freezed == pathProofAddress ? _self.pathProofAddress : pathProofAddress // ignore: cast_nullable_to_non_nullable
as String?,pathTaxCertificate: freezed == pathTaxCertificate ? _self.pathTaxCertificate : pathTaxCertificate // ignore: cast_nullable_to_non_nullable
as String?,validationStatus: freezed == validationStatus ? _self.validationStatus : validationStatus // ignore: cast_nullable_to_non_nullable
as String?,wasteTypeIds: null == wasteTypeIds ? _self._wasteTypeIds : wasteTypeIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
