// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waste_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WasteCollection {

 int get id; int get idWasteType; int get idSegregator; DateTime get collDate; bool get isComplete;// Campos de la entrega (pueden ser null)
 String? get idCollectionCenter; String? get ccenterName; DateTime? get paymentDate; int? get massGrams; double? get bruteAmount; double? get commission; double? get netAmount;
/// Create a copy of WasteCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasteCollectionCopyWith<WasteCollection> get copyWith => _$WasteCollectionCopyWithImpl<WasteCollection>(this as WasteCollection, _$identity);

  /// Serializes this WasteCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasteCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.idWasteType, idWasteType) || other.idWasteType == idWasteType)&&(identical(other.idSegregator, idSegregator) || other.idSegregator == idSegregator)&&(identical(other.collDate, collDate) || other.collDate == collDate)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.idCollectionCenter, idCollectionCenter) || other.idCollectionCenter == idCollectionCenter)&&(identical(other.ccenterName, ccenterName) || other.ccenterName == ccenterName)&&(identical(other.paymentDate, paymentDate) || other.paymentDate == paymentDate)&&(identical(other.massGrams, massGrams) || other.massGrams == massGrams)&&(identical(other.bruteAmount, bruteAmount) || other.bruteAmount == bruteAmount)&&(identical(other.commission, commission) || other.commission == commission)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idWasteType,idSegregator,collDate,isComplete,idCollectionCenter,ccenterName,paymentDate,massGrams,bruteAmount,commission,netAmount);

@override
String toString() {
  return 'WasteCollection(id: $id, idWasteType: $idWasteType, idSegregator: $idSegregator, collDate: $collDate, isComplete: $isComplete, idCollectionCenter: $idCollectionCenter, ccenterName: $ccenterName, paymentDate: $paymentDate, massGrams: $massGrams, bruteAmount: $bruteAmount, commission: $commission, netAmount: $netAmount)';
}


}

/// @nodoc
abstract mixin class $WasteCollectionCopyWith<$Res>  {
  factory $WasteCollectionCopyWith(WasteCollection value, $Res Function(WasteCollection) _then) = _$WasteCollectionCopyWithImpl;
@useResult
$Res call({
 int id, int idWasteType, int idSegregator, DateTime collDate, bool isComplete, String? idCollectionCenter, String? ccenterName, DateTime? paymentDate, int? massGrams, double? bruteAmount, double? commission, double? netAmount
});




}
/// @nodoc
class _$WasteCollectionCopyWithImpl<$Res>
    implements $WasteCollectionCopyWith<$Res> {
  _$WasteCollectionCopyWithImpl(this._self, this._then);

  final WasteCollection _self;
  final $Res Function(WasteCollection) _then;

/// Create a copy of WasteCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idWasteType = null,Object? idSegregator = null,Object? collDate = null,Object? isComplete = null,Object? idCollectionCenter = freezed,Object? ccenterName = freezed,Object? paymentDate = freezed,Object? massGrams = freezed,Object? bruteAmount = freezed,Object? commission = freezed,Object? netAmount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idWasteType: null == idWasteType ? _self.idWasteType : idWasteType // ignore: cast_nullable_to_non_nullable
as int,idSegregator: null == idSegregator ? _self.idSegregator : idSegregator // ignore: cast_nullable_to_non_nullable
as int,collDate: null == collDate ? _self.collDate : collDate // ignore: cast_nullable_to_non_nullable
as DateTime,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,idCollectionCenter: freezed == idCollectionCenter ? _self.idCollectionCenter : idCollectionCenter // ignore: cast_nullable_to_non_nullable
as String?,ccenterName: freezed == ccenterName ? _self.ccenterName : ccenterName // ignore: cast_nullable_to_non_nullable
as String?,paymentDate: freezed == paymentDate ? _self.paymentDate : paymentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,massGrams: freezed == massGrams ? _self.massGrams : massGrams // ignore: cast_nullable_to_non_nullable
as int?,bruteAmount: freezed == bruteAmount ? _self.bruteAmount : bruteAmount // ignore: cast_nullable_to_non_nullable
as double?,commission: freezed == commission ? _self.commission : commission // ignore: cast_nullable_to_non_nullable
as double?,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [WasteCollection].
extension WasteCollectionPatterns on WasteCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WasteCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WasteCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WasteCollection value)  $default,){
final _that = this;
switch (_that) {
case _WasteCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WasteCollection value)?  $default,){
final _that = this;
switch (_that) {
case _WasteCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int idWasteType,  int idSegregator,  DateTime collDate,  bool isComplete,  String? idCollectionCenter,  String? ccenterName,  DateTime? paymentDate,  int? massGrams,  double? bruteAmount,  double? commission,  double? netAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WasteCollection() when $default != null:
return $default(_that.id,_that.idWasteType,_that.idSegregator,_that.collDate,_that.isComplete,_that.idCollectionCenter,_that.ccenterName,_that.paymentDate,_that.massGrams,_that.bruteAmount,_that.commission,_that.netAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int idWasteType,  int idSegregator,  DateTime collDate,  bool isComplete,  String? idCollectionCenter,  String? ccenterName,  DateTime? paymentDate,  int? massGrams,  double? bruteAmount,  double? commission,  double? netAmount)  $default,) {final _that = this;
switch (_that) {
case _WasteCollection():
return $default(_that.id,_that.idWasteType,_that.idSegregator,_that.collDate,_that.isComplete,_that.idCollectionCenter,_that.ccenterName,_that.paymentDate,_that.massGrams,_that.bruteAmount,_that.commission,_that.netAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int idWasteType,  int idSegregator,  DateTime collDate,  bool isComplete,  String? idCollectionCenter,  String? ccenterName,  DateTime? paymentDate,  int? massGrams,  double? bruteAmount,  double? commission,  double? netAmount)?  $default,) {final _that = this;
switch (_that) {
case _WasteCollection() when $default != null:
return $default(_that.id,_that.idWasteType,_that.idSegregator,_that.collDate,_that.isComplete,_that.idCollectionCenter,_that.ccenterName,_that.paymentDate,_that.massGrams,_that.bruteAmount,_that.commission,_that.netAmount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _WasteCollection extends WasteCollection {
  const _WasteCollection({required this.id, required this.idWasteType, required this.idSegregator, required this.collDate, required this.isComplete, this.idCollectionCenter, this.ccenterName, this.paymentDate, this.massGrams, this.bruteAmount, this.commission, this.netAmount}): super._();
  factory _WasteCollection.fromJson(Map<String, dynamic> json) => _$WasteCollectionFromJson(json);

@override final  int id;
@override final  int idWasteType;
@override final  int idSegregator;
@override final  DateTime collDate;
@override final  bool isComplete;
// Campos de la entrega (pueden ser null)
@override final  String? idCollectionCenter;
@override final  String? ccenterName;
@override final  DateTime? paymentDate;
@override final  int? massGrams;
@override final  double? bruteAmount;
@override final  double? commission;
@override final  double? netAmount;

/// Create a copy of WasteCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WasteCollectionCopyWith<_WasteCollection> get copyWith => __$WasteCollectionCopyWithImpl<_WasteCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WasteCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WasteCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.idWasteType, idWasteType) || other.idWasteType == idWasteType)&&(identical(other.idSegregator, idSegregator) || other.idSegregator == idSegregator)&&(identical(other.collDate, collDate) || other.collDate == collDate)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.idCollectionCenter, idCollectionCenter) || other.idCollectionCenter == idCollectionCenter)&&(identical(other.ccenterName, ccenterName) || other.ccenterName == ccenterName)&&(identical(other.paymentDate, paymentDate) || other.paymentDate == paymentDate)&&(identical(other.massGrams, massGrams) || other.massGrams == massGrams)&&(identical(other.bruteAmount, bruteAmount) || other.bruteAmount == bruteAmount)&&(identical(other.commission, commission) || other.commission == commission)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idWasteType,idSegregator,collDate,isComplete,idCollectionCenter,ccenterName,paymentDate,massGrams,bruteAmount,commission,netAmount);

@override
String toString() {
  return 'WasteCollection(id: $id, idWasteType: $idWasteType, idSegregator: $idSegregator, collDate: $collDate, isComplete: $isComplete, idCollectionCenter: $idCollectionCenter, ccenterName: $ccenterName, paymentDate: $paymentDate, massGrams: $massGrams, bruteAmount: $bruteAmount, commission: $commission, netAmount: $netAmount)';
}


}

/// @nodoc
abstract mixin class _$WasteCollectionCopyWith<$Res> implements $WasteCollectionCopyWith<$Res> {
  factory _$WasteCollectionCopyWith(_WasteCollection value, $Res Function(_WasteCollection) _then) = __$WasteCollectionCopyWithImpl;
@override @useResult
$Res call({
 int id, int idWasteType, int idSegregator, DateTime collDate, bool isComplete, String? idCollectionCenter, String? ccenterName, DateTime? paymentDate, int? massGrams, double? bruteAmount, double? commission, double? netAmount
});




}
/// @nodoc
class __$WasteCollectionCopyWithImpl<$Res>
    implements _$WasteCollectionCopyWith<$Res> {
  __$WasteCollectionCopyWithImpl(this._self, this._then);

  final _WasteCollection _self;
  final $Res Function(_WasteCollection) _then;

/// Create a copy of WasteCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idWasteType = null,Object? idSegregator = null,Object? collDate = null,Object? isComplete = null,Object? idCollectionCenter = freezed,Object? ccenterName = freezed,Object? paymentDate = freezed,Object? massGrams = freezed,Object? bruteAmount = freezed,Object? commission = freezed,Object? netAmount = freezed,}) {
  return _then(_WasteCollection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idWasteType: null == idWasteType ? _self.idWasteType : idWasteType // ignore: cast_nullable_to_non_nullable
as int,idSegregator: null == idSegregator ? _self.idSegregator : idSegregator // ignore: cast_nullable_to_non_nullable
as int,collDate: null == collDate ? _self.collDate : collDate // ignore: cast_nullable_to_non_nullable
as DateTime,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,idCollectionCenter: freezed == idCollectionCenter ? _self.idCollectionCenter : idCollectionCenter // ignore: cast_nullable_to_non_nullable
as String?,ccenterName: freezed == ccenterName ? _self.ccenterName : ccenterName // ignore: cast_nullable_to_non_nullable
as String?,paymentDate: freezed == paymentDate ? _self.paymentDate : paymentDate // ignore: cast_nullable_to_non_nullable
as DateTime?,massGrams: freezed == massGrams ? _self.massGrams : massGrams // ignore: cast_nullable_to_non_nullable
as int?,bruteAmount: freezed == bruteAmount ? _self.bruteAmount : bruteAmount // ignore: cast_nullable_to_non_nullable
as double?,commission: freezed == commission ? _self.commission : commission // ignore: cast_nullable_to_non_nullable
as double?,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
