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

// Validation status
// @Default(ValidationStatus.uploading) String? validationStatus,
// UserBase fields
 String get id;// required String? userName,
// required String? surnames,
// required String? phoneNumber,
// required bool? isActive,
// required String? userType,
// required DateTime? createdAt,
// Store fields
// String? companyName,
 String get commercialName;// String? rfc,
// String? taxRegime,
// String? taxpayerType,
 String get address; String get category;// String? bank,
// String? clabe,
// String? billingEmail,
 String get postCode; Map<String, dynamic> get schedule;// Document Paths
 String get pathLogo;// String? pathIdRep,
// String? pathProofAddress,
// String? pathTaxCertificate,
 int? get pointsExchanged;
/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreCopyWith<Store> get copyWith => _$StoreCopyWithImpl<Store>(this as Store, _$identity);

  /// Serializes this Store to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Store&&(identical(other.id, id) || other.id == id)&&(identical(other.commercialName, commercialName) || other.commercialName == commercialName)&&(identical(other.address, address) || other.address == address)&&(identical(other.category, category) || other.category == category)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&const DeepCollectionEquality().equals(other.schedule, schedule)&&(identical(other.pathLogo, pathLogo) || other.pathLogo == pathLogo)&&(identical(other.pointsExchanged, pointsExchanged) || other.pointsExchanged == pointsExchanged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,commercialName,address,category,postCode,const DeepCollectionEquality().hash(schedule),pathLogo,pointsExchanged);

@override
String toString() {
  return 'Store(id: $id, commercialName: $commercialName, address: $address, category: $category, postCode: $postCode, schedule: $schedule, pathLogo: $pathLogo, pointsExchanged: $pointsExchanged)';
}


}

/// @nodoc
abstract mixin class $StoreCopyWith<$Res>  {
  factory $StoreCopyWith(Store value, $Res Function(Store) _then) = _$StoreCopyWithImpl;
@useResult
$Res call({
 String id, String commercialName, String address, String category, String postCode, Map<String, dynamic> schedule, String pathLogo, int? pointsExchanged
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? commercialName = null,Object? address = null,Object? category = null,Object? postCode = null,Object? schedule = null,Object? pathLogo = null,Object? pointsExchanged = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,commercialName: null == commercialName ? _self.commercialName : commercialName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,postCode: null == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,pathLogo: null == pathLogo ? _self.pathLogo : pathLogo // ignore: cast_nullable_to_non_nullable
as String,pointsExchanged: freezed == pointsExchanged ? _self.pointsExchanged : pointsExchanged // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String commercialName,  String address,  String category,  String postCode,  Map<String, dynamic> schedule,  String pathLogo,  int? pointsExchanged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Store() when $default != null:
return $default(_that.id,_that.commercialName,_that.address,_that.category,_that.postCode,_that.schedule,_that.pathLogo,_that.pointsExchanged);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String commercialName,  String address,  String category,  String postCode,  Map<String, dynamic> schedule,  String pathLogo,  int? pointsExchanged)  $default,) {final _that = this;
switch (_that) {
case _Store():
return $default(_that.id,_that.commercialName,_that.address,_that.category,_that.postCode,_that.schedule,_that.pathLogo,_that.pointsExchanged);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String commercialName,  String address,  String category,  String postCode,  Map<String, dynamic> schedule,  String pathLogo,  int? pointsExchanged)?  $default,) {final _that = this;
switch (_that) {
case _Store() when $default != null:
return $default(_that.id,_that.commercialName,_that.address,_that.category,_that.postCode,_that.schedule,_that.pathLogo,_that.pointsExchanged);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Store extends Store {
  const _Store({required this.id, required this.commercialName, required this.address, required this.category, required this.postCode, required final  Map<String, dynamic> schedule, required this.pathLogo, this.pointsExchanged}): _schedule = schedule,super._();
  factory _Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

// Validation status
// @Default(ValidationStatus.uploading) String? validationStatus,
// UserBase fields
@override final  String id;
// required String? userName,
// required String? surnames,
// required String? phoneNumber,
// required bool? isActive,
// required String? userType,
// required DateTime? createdAt,
// Store fields
// String? companyName,
@override final  String commercialName;
// String? rfc,
// String? taxRegime,
// String? taxpayerType,
@override final  String address;
@override final  String category;
// String? bank,
// String? clabe,
// String? billingEmail,
@override final  String postCode;
 final  Map<String, dynamic> _schedule;
@override Map<String, dynamic> get schedule {
  if (_schedule is EqualUnmodifiableMapView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_schedule);
}

// Document Paths
@override final  String pathLogo;
// String? pathIdRep,
// String? pathProofAddress,
// String? pathTaxCertificate,
@override final  int? pointsExchanged;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Store&&(identical(other.id, id) || other.id == id)&&(identical(other.commercialName, commercialName) || other.commercialName == commercialName)&&(identical(other.address, address) || other.address == address)&&(identical(other.category, category) || other.category == category)&&(identical(other.postCode, postCode) || other.postCode == postCode)&&const DeepCollectionEquality().equals(other._schedule, _schedule)&&(identical(other.pathLogo, pathLogo) || other.pathLogo == pathLogo)&&(identical(other.pointsExchanged, pointsExchanged) || other.pointsExchanged == pointsExchanged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,commercialName,address,category,postCode,const DeepCollectionEquality().hash(_schedule),pathLogo,pointsExchanged);

@override
String toString() {
  return 'Store(id: $id, commercialName: $commercialName, address: $address, category: $category, postCode: $postCode, schedule: $schedule, pathLogo: $pathLogo, pointsExchanged: $pointsExchanged)';
}


}

/// @nodoc
abstract mixin class _$StoreCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$StoreCopyWith(_Store value, $Res Function(_Store) _then) = __$StoreCopyWithImpl;
@override @useResult
$Res call({
 String id, String commercialName, String address, String category, String postCode, Map<String, dynamic> schedule, String pathLogo, int? pointsExchanged
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? commercialName = null,Object? address = null,Object? category = null,Object? postCode = null,Object? schedule = null,Object? pathLogo = null,Object? pointsExchanged = freezed,}) {
  return _then(_Store(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,commercialName: null == commercialName ? _self.commercialName : commercialName // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,postCode: null == postCode ? _self.postCode : postCode // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,pathLogo: null == pathLogo ? _self.pathLogo : pathLogo // ignore: cast_nullable_to_non_nullable
as String,pointsExchanged: freezed == pointsExchanged ? _self.pointsExchanged : pointsExchanged // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
