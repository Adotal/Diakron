// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incentive.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Incentive {

 int? get id; String get idStore; int get amount; int get repPercentage; DateTime get createdAt;
/// Create a copy of Incentive
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncentiveCopyWith<Incentive> get copyWith => _$IncentiveCopyWithImpl<Incentive>(this as Incentive, _$identity);

  /// Serializes this Incentive to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Incentive&&(identical(other.id, id) || other.id == id)&&(identical(other.idStore, idStore) || other.idStore == idStore)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.repPercentage, repPercentage) || other.repPercentage == repPercentage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idStore,amount,repPercentage,createdAt);

@override
String toString() {
  return 'Incentive(id: $id, idStore: $idStore, amount: $amount, repPercentage: $repPercentage, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $IncentiveCopyWith<$Res>  {
  factory $IncentiveCopyWith(Incentive value, $Res Function(Incentive) _then) = _$IncentiveCopyWithImpl;
@useResult
$Res call({
 int? id, String idStore, int amount, int repPercentage, DateTime createdAt
});




}
/// @nodoc
class _$IncentiveCopyWithImpl<$Res>
    implements $IncentiveCopyWith<$Res> {
  _$IncentiveCopyWithImpl(this._self, this._then);

  final Incentive _self;
  final $Res Function(Incentive) _then;

/// Create a copy of Incentive
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? idStore = null,Object? amount = null,Object? repPercentage = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,idStore: null == idStore ? _self.idStore : idStore // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,repPercentage: null == repPercentage ? _self.repPercentage : repPercentage // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Incentive].
extension IncentivePatterns on Incentive {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Incentive value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Incentive() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Incentive value)  $default,){
final _that = this;
switch (_that) {
case _Incentive():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Incentive value)?  $default,){
final _that = this;
switch (_that) {
case _Incentive() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String idStore,  int amount,  int repPercentage,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Incentive() when $default != null:
return $default(_that.id,_that.idStore,_that.amount,_that.repPercentage,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String idStore,  int amount,  int repPercentage,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Incentive():
return $default(_that.id,_that.idStore,_that.amount,_that.repPercentage,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String idStore,  int amount,  int repPercentage,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Incentive() when $default != null:
return $default(_that.id,_that.idStore,_that.amount,_that.repPercentage,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Incentive implements Incentive {
  const _Incentive({required this.id, required this.idStore, required this.amount, required this.repPercentage, required this.createdAt});
  factory _Incentive.fromJson(Map<String, dynamic> json) => _$IncentiveFromJson(json);

@override final  int? id;
@override final  String idStore;
@override final  int amount;
@override final  int repPercentage;
@override final  DateTime createdAt;

/// Create a copy of Incentive
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncentiveCopyWith<_Incentive> get copyWith => __$IncentiveCopyWithImpl<_Incentive>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncentiveToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Incentive&&(identical(other.id, id) || other.id == id)&&(identical(other.idStore, idStore) || other.idStore == idStore)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.repPercentage, repPercentage) || other.repPercentage == repPercentage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idStore,amount,repPercentage,createdAt);

@override
String toString() {
  return 'Incentive(id: $id, idStore: $idStore, amount: $amount, repPercentage: $repPercentage, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$IncentiveCopyWith<$Res> implements $IncentiveCopyWith<$Res> {
  factory _$IncentiveCopyWith(_Incentive value, $Res Function(_Incentive) _then) = __$IncentiveCopyWithImpl;
@override @useResult
$Res call({
 int? id, String idStore, int amount, int repPercentage, DateTime createdAt
});




}
/// @nodoc
class __$IncentiveCopyWithImpl<$Res>
    implements _$IncentiveCopyWith<$Res> {
  __$IncentiveCopyWithImpl(this._self, this._then);

  final _Incentive _self;
  final $Res Function(_Incentive) _then;

/// Create a copy of Incentive
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? idStore = null,Object? amount = null,Object? repPercentage = null,Object? createdAt = null,}) {
  return _then(_Incentive(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,idStore: null == idStore ? _self.idStore : idStore // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,repPercentage: null == repPercentage ? _self.repPercentage : repPercentage // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
