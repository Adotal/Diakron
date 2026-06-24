// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Store {

@JsonKey(includeToJson: false) String? get email;// Validation status
 String? get validationStatus;// UserBase fields
 String? get id; String? get userName; String? get surnames; String? get phoneNumber; bool? get isActive; String? get userType; DateTime? get createdAt;// Store fields
 String? get companyName; String? get commercialName; String? get rfc; String? get taxRegime; String? get taxpayerType; String? get address; String? get category; String? get bank; String? get clabe; String? get billingEmail; String? get postCode; Map<String, dynamic>? get schedule;// Document Paths
 String? get pathLogo; String? get pathIdRep; String? get pathProofAddress; String? get pathTaxCertificate;@JsonKey(includeToJson: false) String? get mpAccessToken;// This properties ared needed for store, but not manually stored in DB
@JsonKey(includeToJson: false) int get pointsExchanged;@JsonKey(includeToJson: false) int get firstExchangesParticipant;
/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreCopyWith<Store> get copyWith => _$StoreCopyWithImpl<Store>(this as Store, _$identity);

  /// Serializes this Store to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Store&&(identical(other.email, email) || other.email == email)&&(identical(other.validationStatus, validationStatus) || other.validationStatus == validationStatus)&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.commercialName, commercialName) || other.commercialName == commercialName)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.taxRegime, taxRegime) || other.taxRegime == taxRegime)&&(identical(other.taxpayerType, taxpayerType) || other.taxpayerType == taxpayerType)&&(identical(other.address, address) || other.address == address)&&(identical(other.category, category) || other.category == category)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.clabe, clabe) || other.clabe == clabe)&&(identical(other.billingEmail, billingEmail) || other.billingEmail == billingEmail)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&const DeepCollectionEquality().equals(other.schedule, schedule)&&(identical(other.pathLogo, pathLogo) || other.pathLogo == pathLogo)&&(identical(other.pathIdRep, pathIdRep) || other.pathIdRep == pathIdRep)&&(identical(other.pathProofAddress, pathProofAddress) || other.pathProofAddress == pathProofAddress)&&(identical(other.pathTaxCertificate, pathTaxCertificate) || other.pathTaxCertificate == pathTaxCertificate)&&(identical(other.mpAccessToken, mpAccessToken) || other.mpAccessToken == mpAccessToken)&&(identical(other.pointsExchanged, pointsExchanged) || other.pointsExchanged == pointsExchanged)&&(identical(other.firstExchangesParticipant, firstExchangesParticipant) || other.firstExchangesParticipant == firstExchangesParticipant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,email,validationStatus,id,userName,surnames,phoneNumber,isActive,userType,createdAt,companyName,commercialName,rfc,taxRegime,taxpayerType,address,category,bank,clabe,billingEmail,postCode,const DeepCollectionEquality().hash(schedule),pathLogo,pathIdRep,pathProofAddress,pathTaxCertificate,mpAccessToken,pointsExchanged,firstExchangesParticipant]);

@override
String toString() {
  return 'Store(email: $email, validationStatus: $validationStatus, id: $id, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, companyName: $companyName, commercialName: $commercialName, rfc: $rfc, taxRegime: $taxRegime, taxpayerType: $taxpayerType, address: $address, category: $category, bank: $bank, clabe: $clabe, billingEmail: $billingEmail, postCode: $postCode, schedule: $schedule, pathLogo: $pathLogo, pathIdRep: $pathIdRep, pathProofAddress: $pathProofAddress, pathTaxCertificate: $pathTaxCertificate, mpAccessToken: $mpAccessToken, pointsExchanged: $pointsExchanged, firstExchangesParticipant: $firstExchangesParticipant)';
}


}

/// @nodoc
abstract mixin class $StoreCopyWith<$Res>  {
  factory $StoreCopyWith(Store value, $Res Function(Store) _then) = _$StoreCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String? email, String? validationStatus, String? id, String? userName, String? surnames, String? phoneNumber, bool? isActive, String? userType, DateTime? createdAt, String? companyName, String? commercialName, String? rfc, String? taxRegime, String? taxpayerType, String? address, String? category, String? bank, String? clabe, String? billingEmail, String? postCode, Map<String, dynamic>? schedule, String? pathLogo, String? pathIdRep, String? pathProofAddress, String? pathTaxCertificate,@JsonKey(includeToJson: false) String? mpAccessToken,@JsonKey(includeToJson: false) int pointsExchanged,@JsonKey(includeToJson: false) int firstExchangesParticipant
});




}
/// @nodoc
class _$StoreCopyWithImpl<$Res>
    implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._self, this._then);

  final Store _self;
  final $Res Function(Store) _then;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? validationStatus = freezed,Object? id = freezed,Object? userName = freezed,Object? surnames = freezed,Object? phoneNumber = freezed,Object? isActive = freezed,Object? userType = freezed,Object? createdAt = freezed,Object? companyName = freezed,Object? commercialName = freezed,Object? rfc = freezed,Object? taxRegime = freezed,Object? taxpayerType = freezed,Object? address = freezed,Object? category = freezed,Object? bank = freezed,Object? clabe = freezed,Object? billingEmail = freezed,Object? postCode = freezed,Object? schedule = freezed,Object? pathLogo = freezed,Object? pathIdRep = freezed,Object? pathProofAddress = freezed,Object? pathTaxCertificate = freezed,Object? mpAccessToken = freezed,Object? pointsExchanged = null,Object? firstExchangesParticipant = null,}) {
  return _then(_self.copyWith(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,validationStatus: freezed == validationStatus ? _self.validationStatus : validationStatus // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,surnames: freezed == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,commercialName: freezed == commercialName ? _self.commercialName : commercialName // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,taxRegime: freezed == taxRegime ? _self.taxRegime : taxRegime // ignore: cast_nullable_to_non_nullable
as String?,taxpayerType: freezed == taxpayerType ? _self.taxpayerType : taxpayerType // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as String?,clabe: freezed == clabe ? _self.clabe : clabe // ignore: cast_nullable_to_non_nullable
as String?,billingEmail: freezed == billingEmail ? _self.billingEmail : billingEmail // ignore: cast_nullable_to_non_nullable
as String?,postCode: freezed == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,pathLogo: freezed == pathLogo ? _self.pathLogo : pathLogo // ignore: cast_nullable_to_non_nullable
as String?,pathIdRep: freezed == pathIdRep ? _self.pathIdRep : pathIdRep // ignore: cast_nullable_to_non_nullable
as String?,pathProofAddress: freezed == pathProofAddress ? _self.pathProofAddress : pathProofAddress // ignore: cast_nullable_to_non_nullable
as String?,pathTaxCertificate: freezed == pathTaxCertificate ? _self.pathTaxCertificate : pathTaxCertificate // ignore: cast_nullable_to_non_nullable
as String?,mpAccessToken: freezed == mpAccessToken ? _self.mpAccessToken : mpAccessToken // ignore: cast_nullable_to_non_nullable
as String?,pointsExchanged: null == pointsExchanged ? _self.pointsExchanged : pointsExchanged // ignore: cast_nullable_to_non_nullable
as int,firstExchangesParticipant: null == firstExchangesParticipant ? _self.firstExchangesParticipant : firstExchangesParticipant // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Store].
extension StorePatterns on Store {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Store value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Store() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Store value)  $default,){
final _that = this;
switch (_that) {
case _Store():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Store value)?  $default,){
final _that = this;
switch (_that) {
case _Store() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? email,  String? validationStatus,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? companyName,  String? commercialName,  String? rfc,  String? taxRegime,  String? taxpayerType,  String? address,  String? category,  String? bank,  String? clabe,  String? billingEmail,  String? postCode,  Map<String, dynamic>? schedule,  String? pathLogo,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate, @JsonKey(includeToJson: false)  String? mpAccessToken, @JsonKey(includeToJson: false)  int pointsExchanged, @JsonKey(includeToJson: false)  int firstExchangesParticipant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Store() when $default != null:
return $default(_that.email,_that.validationStatus,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.companyName,_that.commercialName,_that.rfc,_that.taxRegime,_that.taxpayerType,_that.address,_that.category,_that.bank,_that.clabe,_that.billingEmail,_that.postCode,_that.schedule,_that.pathLogo,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate,_that.mpAccessToken,_that.pointsExchanged,_that.firstExchangesParticipant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? email,  String? validationStatus,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? companyName,  String? commercialName,  String? rfc,  String? taxRegime,  String? taxpayerType,  String? address,  String? category,  String? bank,  String? clabe,  String? billingEmail,  String? postCode,  Map<String, dynamic>? schedule,  String? pathLogo,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate, @JsonKey(includeToJson: false)  String? mpAccessToken, @JsonKey(includeToJson: false)  int pointsExchanged, @JsonKey(includeToJson: false)  int firstExchangesParticipant)  $default,) {final _that = this;
switch (_that) {
case _Store():
return $default(_that.email,_that.validationStatus,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.companyName,_that.commercialName,_that.rfc,_that.taxRegime,_that.taxpayerType,_that.address,_that.category,_that.bank,_that.clabe,_that.billingEmail,_that.postCode,_that.schedule,_that.pathLogo,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate,_that.mpAccessToken,_that.pointsExchanged,_that.firstExchangesParticipant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String? email,  String? validationStatus,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  String? companyName,  String? commercialName,  String? rfc,  String? taxRegime,  String? taxpayerType,  String? address,  String? category,  String? bank,  String? clabe,  String? billingEmail,  String? postCode,  Map<String, dynamic>? schedule,  String? pathLogo,  String? pathIdRep,  String? pathProofAddress,  String? pathTaxCertificate, @JsonKey(includeToJson: false)  String? mpAccessToken, @JsonKey(includeToJson: false)  int pointsExchanged, @JsonKey(includeToJson: false)  int firstExchangesParticipant)?  $default,) {final _that = this;
switch (_that) {
case _Store() when $default != null:
return $default(_that.email,_that.validationStatus,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.companyName,_that.commercialName,_that.rfc,_that.taxRegime,_that.taxpayerType,_that.address,_that.category,_that.bank,_that.clabe,_that.billingEmail,_that.postCode,_that.schedule,_that.pathLogo,_that.pathIdRep,_that.pathProofAddress,_that.pathTaxCertificate,_that.mpAccessToken,_that.pointsExchanged,_that.firstExchangesParticipant);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Store extends Store {
  const _Store({@JsonKey(includeToJson: false) required this.email, this.validationStatus = ValidationStatus.uploading, required this.id, required this.userName, required this.surnames, required this.phoneNumber, required this.isActive, required this.userType, required this.createdAt, this.companyName, this.commercialName, this.rfc, this.taxRegime, this.taxpayerType, this.address, this.category, this.bank, this.clabe, this.billingEmail, this.postCode, final  Map<String, dynamic>? schedule, this.pathLogo, this.pathIdRep, this.pathProofAddress, this.pathTaxCertificate, @JsonKey(includeToJson: false) this.mpAccessToken, @JsonKey(includeToJson: false) this.pointsExchanged = 0, @JsonKey(includeToJson: false) this.firstExchangesParticipant = 0}): _schedule = schedule,super._();
  factory _Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

@override@JsonKey(includeToJson: false) final  String? email;
// Validation status
@override@JsonKey() final  String? validationStatus;
// UserBase fields
@override final  String? id;
@override final  String? userName;
@override final  String? surnames;
@override final  String? phoneNumber;
@override final  bool? isActive;
@override final  String? userType;
@override final  DateTime? createdAt;
// Store fields
@override final  String? companyName;
@override final  String? commercialName;
@override final  String? rfc;
@override final  String? taxRegime;
@override final  String? taxpayerType;
@override final  String? address;
@override final  String? category;
@override final  String? bank;
@override final  String? clabe;
@override final  String? billingEmail;
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
@override final  String? pathLogo;
@override final  String? pathIdRep;
@override final  String? pathProofAddress;
@override final  String? pathTaxCertificate;
@override@JsonKey(includeToJson: false) final  String? mpAccessToken;
// This properties ared needed for store, but not manually stored in DB
@override@JsonKey(includeToJson: false) final  int pointsExchanged;
@override@JsonKey(includeToJson: false) final  int firstExchangesParticipant;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreCopyWith<_Store> get copyWith => __$StoreCopyWithImpl<_Store>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Store&&(identical(other.email, email) || other.email == email)&&(identical(other.validationStatus, validationStatus) || other.validationStatus == validationStatus)&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.commercialName, commercialName) || other.commercialName == commercialName)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.taxRegime, taxRegime) || other.taxRegime == taxRegime)&&(identical(other.taxpayerType, taxpayerType) || other.taxpayerType == taxpayerType)&&(identical(other.address, address) || other.address == address)&&(identical(other.category, category) || other.category == category)&&(identical(other.bank, bank) || other.bank == bank)&&(identical(other.clabe, clabe) || other.clabe == clabe)&&(identical(other.billingEmail, billingEmail) || other.billingEmail == billingEmail)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&const DeepCollectionEquality().equals(other._schedule, _schedule)&&(identical(other.pathLogo, pathLogo) || other.pathLogo == pathLogo)&&(identical(other.pathIdRep, pathIdRep) || other.pathIdRep == pathIdRep)&&(identical(other.pathProofAddress, pathProofAddress) || other.pathProofAddress == pathProofAddress)&&(identical(other.pathTaxCertificate, pathTaxCertificate) || other.pathTaxCertificate == pathTaxCertificate)&&(identical(other.mpAccessToken, mpAccessToken) || other.mpAccessToken == mpAccessToken)&&(identical(other.pointsExchanged, pointsExchanged) || other.pointsExchanged == pointsExchanged)&&(identical(other.firstExchangesParticipant, firstExchangesParticipant) || other.firstExchangesParticipant == firstExchangesParticipant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,email,validationStatus,id,userName,surnames,phoneNumber,isActive,userType,createdAt,companyName,commercialName,rfc,taxRegime,taxpayerType,address,category,bank,clabe,billingEmail,postCode,const DeepCollectionEquality().hash(_schedule),pathLogo,pathIdRep,pathProofAddress,pathTaxCertificate,mpAccessToken,pointsExchanged,firstExchangesParticipant]);

@override
String toString() {
  return 'Store(email: $email, validationStatus: $validationStatus, id: $id, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, companyName: $companyName, commercialName: $commercialName, rfc: $rfc, taxRegime: $taxRegime, taxpayerType: $taxpayerType, address: $address, category: $category, bank: $bank, clabe: $clabe, billingEmail: $billingEmail, postCode: $postCode, schedule: $schedule, pathLogo: $pathLogo, pathIdRep: $pathIdRep, pathProofAddress: $pathProofAddress, pathTaxCertificate: $pathTaxCertificate, mpAccessToken: $mpAccessToken, pointsExchanged: $pointsExchanged, firstExchangesParticipant: $firstExchangesParticipant)';
}


}

/// @nodoc
abstract mixin class _$StoreCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$StoreCopyWith(_Store value, $Res Function(_Store) _then) = __$StoreCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String? email, String? validationStatus, String? id, String? userName, String? surnames, String? phoneNumber, bool? isActive, String? userType, DateTime? createdAt, String? companyName, String? commercialName, String? rfc, String? taxRegime, String? taxpayerType, String? address, String? category, String? bank, String? clabe, String? billingEmail, String? postCode, Map<String, dynamic>? schedule, String? pathLogo, String? pathIdRep, String? pathProofAddress, String? pathTaxCertificate,@JsonKey(includeToJson: false) String? mpAccessToken,@JsonKey(includeToJson: false) int pointsExchanged,@JsonKey(includeToJson: false) int firstExchangesParticipant
});




}
/// @nodoc
class __$StoreCopyWithImpl<$Res>
    implements _$StoreCopyWith<$Res> {
  __$StoreCopyWithImpl(this._self, this._then);

  final _Store _self;
  final $Res Function(_Store) _then;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? validationStatus = freezed,Object? id = freezed,Object? userName = freezed,Object? surnames = freezed,Object? phoneNumber = freezed,Object? isActive = freezed,Object? userType = freezed,Object? createdAt = freezed,Object? companyName = freezed,Object? commercialName = freezed,Object? rfc = freezed,Object? taxRegime = freezed,Object? taxpayerType = freezed,Object? address = freezed,Object? category = freezed,Object? bank = freezed,Object? clabe = freezed,Object? billingEmail = freezed,Object? postCode = freezed,Object? schedule = freezed,Object? pathLogo = freezed,Object? pathIdRep = freezed,Object? pathProofAddress = freezed,Object? pathTaxCertificate = freezed,Object? mpAccessToken = freezed,Object? pointsExchanged = null,Object? firstExchangesParticipant = null,}) {
  return _then(_Store(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,validationStatus: freezed == validationStatus ? _self.validationStatus : validationStatus // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,surnames: freezed == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,commercialName: freezed == commercialName ? _self.commercialName : commercialName // ignore: cast_nullable_to_non_nullable
as String?,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,taxRegime: freezed == taxRegime ? _self.taxRegime : taxRegime // ignore: cast_nullable_to_non_nullable
as String?,taxpayerType: freezed == taxpayerType ? _self.taxpayerType : taxpayerType // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,bank: freezed == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as String?,clabe: freezed == clabe ? _self.clabe : clabe // ignore: cast_nullable_to_non_nullable
as String?,billingEmail: freezed == billingEmail ? _self.billingEmail : billingEmail // ignore: cast_nullable_to_non_nullable
as String?,postCode: freezed == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String?,schedule: freezed == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,pathLogo: freezed == pathLogo ? _self.pathLogo : pathLogo // ignore: cast_nullable_to_non_nullable
as String?,pathIdRep: freezed == pathIdRep ? _self.pathIdRep : pathIdRep // ignore: cast_nullable_to_non_nullable
as String?,pathProofAddress: freezed == pathProofAddress ? _self.pathProofAddress : pathProofAddress // ignore: cast_nullable_to_non_nullable
as String?,pathTaxCertificate: freezed == pathTaxCertificate ? _self.pathTaxCertificate : pathTaxCertificate // ignore: cast_nullable_to_non_nullable
as String?,mpAccessToken: freezed == mpAccessToken ? _self.mpAccessToken : mpAccessToken // ignore: cast_nullable_to_non_nullable
as String?,pointsExchanged: null == pointsExchanged ? _self.pointsExchanged : pointsExchanged // ignore: cast_nullable_to_non_nullable
as int,firstExchangesParticipant: null == firstExchangesParticipant ? _self.firstExchangesParticipant : firstExchangesParticipant // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
