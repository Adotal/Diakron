// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BinModel {

 int get id; int get idWasteType; String get wasteType; DateTime get lastDate; int? get totalMass; int get fillingPercentage;
/// Create a copy of BinModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BinModelCopyWith<BinModel> get copyWith => _$BinModelCopyWithImpl<BinModel>(this as BinModel, _$identity);

  /// Serializes this BinModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BinModel&&(identical(other.id, id) || other.id == id)&&(identical(other.idWasteType, idWasteType) || other.idWasteType == idWasteType)&&(identical(other.wasteType, wasteType) || other.wasteType == wasteType)&&(identical(other.lastDate, lastDate) || other.lastDate == lastDate)&&(identical(other.totalMass, totalMass) || other.totalMass == totalMass)&&(identical(other.fillingPercentage, fillingPercentage) || other.fillingPercentage == fillingPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idWasteType,wasteType,lastDate,totalMass,fillingPercentage);

@override
String toString() {
  return 'BinModel(id: $id, idWasteType: $idWasteType, wasteType: $wasteType, lastDate: $lastDate, totalMass: $totalMass, fillingPercentage: $fillingPercentage)';
}


}

/// @nodoc
abstract mixin class $BinModelCopyWith<$Res>  {
  factory $BinModelCopyWith(BinModel value, $Res Function(BinModel) _then) = _$BinModelCopyWithImpl;
@useResult
$Res call({
 int id, int idWasteType, String wasteType, DateTime lastDate, int? totalMass, int fillingPercentage
});




}
/// @nodoc
class _$BinModelCopyWithImpl<$Res>
    implements $BinModelCopyWith<$Res> {
  _$BinModelCopyWithImpl(this._self, this._then);

  final BinModel _self;
  final $Res Function(BinModel) _then;

/// Create a copy of BinModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idWasteType = null,Object? wasteType = null,Object? lastDate = null,Object? totalMass = freezed,Object? fillingPercentage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idWasteType: null == idWasteType ? _self.idWasteType : idWasteType // ignore: cast_nullable_to_non_nullable
as int,wasteType: null == wasteType ? _self.wasteType : wasteType // ignore: cast_nullable_to_non_nullable
as String,lastDate: null == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalMass: freezed == totalMass ? _self.totalMass : totalMass // ignore: cast_nullable_to_non_nullable
as int?,fillingPercentage: null == fillingPercentage ? _self.fillingPercentage : fillingPercentage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BinModel].
extension BinModelPatterns on BinModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BinModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BinModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BinModel value)  $default,){
final _that = this;
switch (_that) {
case _BinModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BinModel value)?  $default,){
final _that = this;
switch (_that) {
case _BinModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int idWasteType,  String wasteType,  DateTime lastDate,  int? totalMass,  int fillingPercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BinModel() when $default != null:
return $default(_that.id,_that.idWasteType,_that.wasteType,_that.lastDate,_that.totalMass,_that.fillingPercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int idWasteType,  String wasteType,  DateTime lastDate,  int? totalMass,  int fillingPercentage)  $default,) {final _that = this;
switch (_that) {
case _BinModel():
return $default(_that.id,_that.idWasteType,_that.wasteType,_that.lastDate,_that.totalMass,_that.fillingPercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int idWasteType,  String wasteType,  DateTime lastDate,  int? totalMass,  int fillingPercentage)?  $default,) {final _that = this;
switch (_that) {
case _BinModel() when $default != null:
return $default(_that.id,_that.idWasteType,_that.wasteType,_that.lastDate,_that.totalMass,_that.fillingPercentage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _BinModel implements BinModel {
  const _BinModel({required this.id, required this.idWasteType, required this.wasteType, required this.lastDate, this.totalMass, required this.fillingPercentage});
  factory _BinModel.fromJson(Map<String, dynamic> json) => _$BinModelFromJson(json);

@override final  int id;
@override final  int idWasteType;
@override final  String wasteType;
@override final  DateTime lastDate;
@override final  int? totalMass;
@override final  int fillingPercentage;

/// Create a copy of BinModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BinModelCopyWith<_BinModel> get copyWith => __$BinModelCopyWithImpl<_BinModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BinModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BinModel&&(identical(other.id, id) || other.id == id)&&(identical(other.idWasteType, idWasteType) || other.idWasteType == idWasteType)&&(identical(other.wasteType, wasteType) || other.wasteType == wasteType)&&(identical(other.lastDate, lastDate) || other.lastDate == lastDate)&&(identical(other.totalMass, totalMass) || other.totalMass == totalMass)&&(identical(other.fillingPercentage, fillingPercentage) || other.fillingPercentage == fillingPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idWasteType,wasteType,lastDate,totalMass,fillingPercentage);

@override
String toString() {
  return 'BinModel(id: $id, idWasteType: $idWasteType, wasteType: $wasteType, lastDate: $lastDate, totalMass: $totalMass, fillingPercentage: $fillingPercentage)';
}


}

/// @nodoc
abstract mixin class _$BinModelCopyWith<$Res> implements $BinModelCopyWith<$Res> {
  factory _$BinModelCopyWith(_BinModel value, $Res Function(_BinModel) _then) = __$BinModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int idWasteType, String wasteType, DateTime lastDate, int? totalMass, int fillingPercentage
});




}
/// @nodoc
class __$BinModelCopyWithImpl<$Res>
    implements _$BinModelCopyWith<$Res> {
  __$BinModelCopyWithImpl(this._self, this._then);

  final _BinModel _self;
  final $Res Function(_BinModel) _then;

/// Create a copy of BinModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idWasteType = null,Object? wasteType = null,Object? lastDate = null,Object? totalMass = freezed,Object? fillingPercentage = null,}) {
  return _then(_BinModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idWasteType: null == idWasteType ? _self.idWasteType : idWasteType // ignore: cast_nullable_to_non_nullable
as int,wasteType: null == wasteType ? _self.wasteType : wasteType // ignore: cast_nullable_to_non_nullable
as String,lastDate: null == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalMass: freezed == totalMass ? _self.totalMass : totalMass // ignore: cast_nullable_to_non_nullable
as int?,fillingPercentage: null == fillingPercentage ? _self.fillingPercentage : fillingPercentage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
