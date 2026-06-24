// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Coupon {

 int? get id; String get idStore; String get title; String get descript; int get pricePoints; DateTime get expirationDate; int? get couponsLeft; bool get isActive; String get pathImage;
/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponCopyWith<Coupon> get copyWith => _$CouponCopyWithImpl<Coupon>(this as Coupon, _$identity);

  /// Serializes this Coupon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Coupon&&(identical(other.id, id) || other.id == id)&&(identical(other.idStore, idStore) || other.idStore == idStore)&&(identical(other.title, title) || other.title == title)&&(identical(other.descript, descript) || other.descript == descript)&&(identical(other.pricePoints, pricePoints) || other.pricePoints == pricePoints)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.couponsLeft, couponsLeft) || other.couponsLeft == couponsLeft)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.pathImage, pathImage) || other.pathImage == pathImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idStore,title,descript,pricePoints,expirationDate,couponsLeft,isActive,pathImage);

@override
String toString() {
  return 'Coupon(id: $id, idStore: $idStore, title: $title, descript: $descript, pricePoints: $pricePoints, expirationDate: $expirationDate, couponsLeft: $couponsLeft, isActive: $isActive, pathImage: $pathImage)';
}


}

/// @nodoc
abstract mixin class $CouponCopyWith<$Res>  {
  factory $CouponCopyWith(Coupon value, $Res Function(Coupon) _then) = _$CouponCopyWithImpl;
@useResult
$Res call({
 int? id, String idStore, String title, String descript, int pricePoints, DateTime expirationDate, int? couponsLeft, bool isActive, String pathImage
});




}
/// @nodoc
class _$CouponCopyWithImpl<$Res>
    implements $CouponCopyWith<$Res> {
  _$CouponCopyWithImpl(this._self, this._then);

  final Coupon _self;
  final $Res Function(Coupon) _then;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? idStore = null,Object? title = null,Object? descript = null,Object? pricePoints = null,Object? expirationDate = null,Object? couponsLeft = freezed,Object? isActive = null,Object? pathImage = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,idStore: null == idStore ? _self.idStore : idStore // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,descript: null == descript ? _self.descript : descript // ignore: cast_nullable_to_non_nullable
as String,pricePoints: null == pricePoints ? _self.pricePoints : pricePoints // ignore: cast_nullable_to_non_nullable
as int,expirationDate: null == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime,couponsLeft: freezed == couponsLeft ? _self.couponsLeft : couponsLeft // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,pathImage: null == pathImage ? _self.pathImage : pathImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Coupon].
extension CouponPatterns on Coupon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Coupon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Coupon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Coupon value)  $default,){
final _that = this;
switch (_that) {
case _Coupon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Coupon value)?  $default,){
final _that = this;
switch (_that) {
case _Coupon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String idStore,  String title,  String descript,  int pricePoints,  DateTime expirationDate,  int? couponsLeft,  bool isActive,  String pathImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Coupon() when $default != null:
return $default(_that.id,_that.idStore,_that.title,_that.descript,_that.pricePoints,_that.expirationDate,_that.couponsLeft,_that.isActive,_that.pathImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String idStore,  String title,  String descript,  int pricePoints,  DateTime expirationDate,  int? couponsLeft,  bool isActive,  String pathImage)  $default,) {final _that = this;
switch (_that) {
case _Coupon():
return $default(_that.id,_that.idStore,_that.title,_that.descript,_that.pricePoints,_that.expirationDate,_that.couponsLeft,_that.isActive,_that.pathImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String idStore,  String title,  String descript,  int pricePoints,  DateTime expirationDate,  int? couponsLeft,  bool isActive,  String pathImage)?  $default,) {final _that = this;
switch (_that) {
case _Coupon() when $default != null:
return $default(_that.id,_that.idStore,_that.title,_that.descript,_that.pricePoints,_that.expirationDate,_that.couponsLeft,_that.isActive,_that.pathImage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Coupon extends Coupon {
  const _Coupon({required this.id, required this.idStore, required this.title, required this.descript, required this.pricePoints, required this.expirationDate, required this.couponsLeft, required this.isActive, required this.pathImage}): super._();
  factory _Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

@override final  int? id;
@override final  String idStore;
@override final  String title;
@override final  String descript;
@override final  int pricePoints;
@override final  DateTime expirationDate;
@override final  int? couponsLeft;
@override final  bool isActive;
@override final  String pathImage;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouponCopyWith<_Coupon> get copyWith => __$CouponCopyWithImpl<_Coupon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CouponToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Coupon&&(identical(other.id, id) || other.id == id)&&(identical(other.idStore, idStore) || other.idStore == idStore)&&(identical(other.title, title) || other.title == title)&&(identical(other.descript, descript) || other.descript == descript)&&(identical(other.pricePoints, pricePoints) || other.pricePoints == pricePoints)&&(identical(other.expirationDate, expirationDate) || other.expirationDate == expirationDate)&&(identical(other.couponsLeft, couponsLeft) || other.couponsLeft == couponsLeft)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.pathImage, pathImage) || other.pathImage == pathImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idStore,title,descript,pricePoints,expirationDate,couponsLeft,isActive,pathImage);

@override
String toString() {
  return 'Coupon(id: $id, idStore: $idStore, title: $title, descript: $descript, pricePoints: $pricePoints, expirationDate: $expirationDate, couponsLeft: $couponsLeft, isActive: $isActive, pathImage: $pathImage)';
}


}

/// @nodoc
abstract mixin class _$CouponCopyWith<$Res> implements $CouponCopyWith<$Res> {
  factory _$CouponCopyWith(_Coupon value, $Res Function(_Coupon) _then) = __$CouponCopyWithImpl;
@override @useResult
$Res call({
 int? id, String idStore, String title, String descript, int pricePoints, DateTime expirationDate, int? couponsLeft, bool isActive, String pathImage
});




}
/// @nodoc
class __$CouponCopyWithImpl<$Res>
    implements _$CouponCopyWith<$Res> {
  __$CouponCopyWithImpl(this._self, this._then);

  final _Coupon _self;
  final $Res Function(_Coupon) _then;

/// Create a copy of Coupon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? idStore = null,Object? title = null,Object? descript = null,Object? pricePoints = null,Object? expirationDate = null,Object? couponsLeft = freezed,Object? isActive = null,Object? pathImage = null,}) {
  return _then(_Coupon(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,idStore: null == idStore ? _self.idStore : idStore // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,descript: null == descript ? _self.descript : descript // ignore: cast_nullable_to_non_nullable
as String,pricePoints: null == pricePoints ? _self.pricePoints : pricePoints // ignore: cast_nullable_to_non_nullable
as int,expirationDate: null == expirationDate ? _self.expirationDate : expirationDate // ignore: cast_nullable_to_non_nullable
as DateTime,couponsLeft: freezed == couponsLeft ? _self.couponsLeft : couponsLeft // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,pathImage: null == pathImage ? _self.pathImage : pathImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
