// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waste_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WasteType {

// UserBase fields
 int get id; String? get wasteType;
/// Create a copy of WasteType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasteTypeCopyWith<WasteType> get copyWith => _$WasteTypeCopyWithImpl<WasteType>(this as WasteType, _$identity);

  /// Serializes this WasteType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasteType&&(identical(other.id, id) || other.id == id)&&(identical(other.wasteType, wasteType) || other.wasteType == wasteType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,wasteType);

@override
String toString() {
  return 'WasteType(id: $id, wasteType: $wasteType)';
}


}

/// @nodoc
abstract mixin class $WasteTypeCopyWith<$Res>  {
  factory $WasteTypeCopyWith(WasteType value, $Res Function(WasteType) _then) = _$WasteTypeCopyWithImpl;
@useResult
$Res call({
 int id, String? wasteType
});




}
/// @nodoc
class _$WasteTypeCopyWithImpl<$Res>
    implements $WasteTypeCopyWith<$Res> {
  _$WasteTypeCopyWithImpl(this._self, this._then);

  final WasteType _self;
  final $Res Function(WasteType) _then;

/// Create a copy of WasteType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? wasteType = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,wasteType: freezed == wasteType ? _self.wasteType : wasteType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WasteType].
extension WasteTypePatterns on WasteType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WasteType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WasteType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WasteType value)  $default,){
final _that = this;
switch (_that) {
case _WasteType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WasteType value)?  $default,){
final _that = this;
switch (_that) {
case _WasteType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? wasteType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WasteType() when $default != null:
return $default(_that.id,_that.wasteType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? wasteType)  $default,) {final _that = this;
switch (_that) {
case _WasteType():
return $default(_that.id,_that.wasteType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? wasteType)?  $default,) {final _that = this;
switch (_that) {
case _WasteType() when $default != null:
return $default(_that.id,_that.wasteType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _WasteType implements WasteType {
  const _WasteType({required this.id, required this.wasteType});
  factory _WasteType.fromJson(Map<String, dynamic> json) => _$WasteTypeFromJson(json);

// UserBase fields
@override final  int id;
@override final  String? wasteType;

/// Create a copy of WasteType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WasteTypeCopyWith<_WasteType> get copyWith => __$WasteTypeCopyWithImpl<_WasteType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WasteTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WasteType&&(identical(other.id, id) || other.id == id)&&(identical(other.wasteType, wasteType) || other.wasteType == wasteType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,wasteType);

@override
String toString() {
  return 'WasteType(id: $id, wasteType: $wasteType)';
}


}

/// @nodoc
abstract mixin class _$WasteTypeCopyWith<$Res> implements $WasteTypeCopyWith<$Res> {
  factory _$WasteTypeCopyWith(_WasteType value, $Res Function(_WasteType) _then) = __$WasteTypeCopyWithImpl;
@override @useResult
$Res call({
 int id, String? wasteType
});




}
/// @nodoc
class __$WasteTypeCopyWithImpl<$Res>
    implements _$WasteTypeCopyWith<$Res> {
  __$WasteTypeCopyWithImpl(this._self, this._then);

  final _WasteType _self;
  final $Res Function(_WasteType) _then;

/// Create a copy of WasteType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? wasteType = freezed,}) {
  return _then(_WasteType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,wasteType: freezed == wasteType ? _self.wasteType : wasteType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
