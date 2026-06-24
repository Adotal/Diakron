// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_waste_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserWasteStats {

 int get countMetal; int get weightMetal; int get countPlastic; int get weightPlastic; int get countGlass; int get weightGlass; int get countPaper; int get weightPaper;
/// Create a copy of UserWasteStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserWasteStatsCopyWith<UserWasteStats> get copyWith => _$UserWasteStatsCopyWithImpl<UserWasteStats>(this as UserWasteStats, _$identity);

  /// Serializes this UserWasteStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserWasteStats&&(identical(other.countMetal, countMetal) || other.countMetal == countMetal)&&(identical(other.weightMetal, weightMetal) || other.weightMetal == weightMetal)&&(identical(other.countPlastic, countPlastic) || other.countPlastic == countPlastic)&&(identical(other.weightPlastic, weightPlastic) || other.weightPlastic == weightPlastic)&&(identical(other.countGlass, countGlass) || other.countGlass == countGlass)&&(identical(other.weightGlass, weightGlass) || other.weightGlass == weightGlass)&&(identical(other.countPaper, countPaper) || other.countPaper == countPaper)&&(identical(other.weightPaper, weightPaper) || other.weightPaper == weightPaper));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countMetal,weightMetal,countPlastic,weightPlastic,countGlass,weightGlass,countPaper,weightPaper);

@override
String toString() {
  return 'UserWasteStats(countMetal: $countMetal, weightMetal: $weightMetal, countPlastic: $countPlastic, weightPlastic: $weightPlastic, countGlass: $countGlass, weightGlass: $weightGlass, countPaper: $countPaper, weightPaper: $weightPaper)';
}


}

/// @nodoc
abstract mixin class $UserWasteStatsCopyWith<$Res>  {
  factory $UserWasteStatsCopyWith(UserWasteStats value, $Res Function(UserWasteStats) _then) = _$UserWasteStatsCopyWithImpl;
@useResult
$Res call({
 int countMetal, int weightMetal, int countPlastic, int weightPlastic, int countGlass, int weightGlass, int countPaper, int weightPaper
});




}
/// @nodoc
class _$UserWasteStatsCopyWithImpl<$Res>
    implements $UserWasteStatsCopyWith<$Res> {
  _$UserWasteStatsCopyWithImpl(this._self, this._then);

  final UserWasteStats _self;
  final $Res Function(UserWasteStats) _then;

/// Create a copy of UserWasteStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countMetal = null,Object? weightMetal = null,Object? countPlastic = null,Object? weightPlastic = null,Object? countGlass = null,Object? weightGlass = null,Object? countPaper = null,Object? weightPaper = null,}) {
  return _then(_self.copyWith(
countMetal: null == countMetal ? _self.countMetal : countMetal // ignore: cast_nullable_to_non_nullable
as int,weightMetal: null == weightMetal ? _self.weightMetal : weightMetal // ignore: cast_nullable_to_non_nullable
as int,countPlastic: null == countPlastic ? _self.countPlastic : countPlastic // ignore: cast_nullable_to_non_nullable
as int,weightPlastic: null == weightPlastic ? _self.weightPlastic : weightPlastic // ignore: cast_nullable_to_non_nullable
as int,countGlass: null == countGlass ? _self.countGlass : countGlass // ignore: cast_nullable_to_non_nullable
as int,weightGlass: null == weightGlass ? _self.weightGlass : weightGlass // ignore: cast_nullable_to_non_nullable
as int,countPaper: null == countPaper ? _self.countPaper : countPaper // ignore: cast_nullable_to_non_nullable
as int,weightPaper: null == weightPaper ? _self.weightPaper : weightPaper // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserWasteStats].
extension UserWasteStatsPatterns on UserWasteStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserWasteStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserWasteStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserWasteStats value)  $default,){
final _that = this;
switch (_that) {
case _UserWasteStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserWasteStats value)?  $default,){
final _that = this;
switch (_that) {
case _UserWasteStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int countMetal,  int weightMetal,  int countPlastic,  int weightPlastic,  int countGlass,  int weightGlass,  int countPaper,  int weightPaper)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserWasteStats() when $default != null:
return $default(_that.countMetal,_that.weightMetal,_that.countPlastic,_that.weightPlastic,_that.countGlass,_that.weightGlass,_that.countPaper,_that.weightPaper);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int countMetal,  int weightMetal,  int countPlastic,  int weightPlastic,  int countGlass,  int weightGlass,  int countPaper,  int weightPaper)  $default,) {final _that = this;
switch (_that) {
case _UserWasteStats():
return $default(_that.countMetal,_that.weightMetal,_that.countPlastic,_that.weightPlastic,_that.countGlass,_that.weightGlass,_that.countPaper,_that.weightPaper);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int countMetal,  int weightMetal,  int countPlastic,  int weightPlastic,  int countGlass,  int weightGlass,  int countPaper,  int weightPaper)?  $default,) {final _that = this;
switch (_that) {
case _UserWasteStats() when $default != null:
return $default(_that.countMetal,_that.weightMetal,_that.countPlastic,_that.weightPlastic,_that.countGlass,_that.weightGlass,_that.countPaper,_that.weightPaper);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserWasteStats extends UserWasteStats {
  const _UserWasteStats({required this.countMetal, required this.weightMetal, required this.countPlastic, required this.weightPlastic, required this.countGlass, required this.weightGlass, required this.countPaper, required this.weightPaper}): super._();
  factory _UserWasteStats.fromJson(Map<String, dynamic> json) => _$UserWasteStatsFromJson(json);

@override final  int countMetal;
@override final  int weightMetal;
@override final  int countPlastic;
@override final  int weightPlastic;
@override final  int countGlass;
@override final  int weightGlass;
@override final  int countPaper;
@override final  int weightPaper;

/// Create a copy of UserWasteStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserWasteStatsCopyWith<_UserWasteStats> get copyWith => __$UserWasteStatsCopyWithImpl<_UserWasteStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserWasteStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserWasteStats&&(identical(other.countMetal, countMetal) || other.countMetal == countMetal)&&(identical(other.weightMetal, weightMetal) || other.weightMetal == weightMetal)&&(identical(other.countPlastic, countPlastic) || other.countPlastic == countPlastic)&&(identical(other.weightPlastic, weightPlastic) || other.weightPlastic == weightPlastic)&&(identical(other.countGlass, countGlass) || other.countGlass == countGlass)&&(identical(other.weightGlass, weightGlass) || other.weightGlass == weightGlass)&&(identical(other.countPaper, countPaper) || other.countPaper == countPaper)&&(identical(other.weightPaper, weightPaper) || other.weightPaper == weightPaper));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countMetal,weightMetal,countPlastic,weightPlastic,countGlass,weightGlass,countPaper,weightPaper);

@override
String toString() {
  return 'UserWasteStats(countMetal: $countMetal, weightMetal: $weightMetal, countPlastic: $countPlastic, weightPlastic: $weightPlastic, countGlass: $countGlass, weightGlass: $weightGlass, countPaper: $countPaper, weightPaper: $weightPaper)';
}


}

/// @nodoc
abstract mixin class _$UserWasteStatsCopyWith<$Res> implements $UserWasteStatsCopyWith<$Res> {
  factory _$UserWasteStatsCopyWith(_UserWasteStats value, $Res Function(_UserWasteStats) _then) = __$UserWasteStatsCopyWithImpl;
@override @useResult
$Res call({
 int countMetal, int weightMetal, int countPlastic, int weightPlastic, int countGlass, int weightGlass, int countPaper, int weightPaper
});




}
/// @nodoc
class __$UserWasteStatsCopyWithImpl<$Res>
    implements _$UserWasteStatsCopyWith<$Res> {
  __$UserWasteStatsCopyWithImpl(this._self, this._then);

  final _UserWasteStats _self;
  final $Res Function(_UserWasteStats) _then;

/// Create a copy of UserWasteStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countMetal = null,Object? weightMetal = null,Object? countPlastic = null,Object? weightPlastic = null,Object? countGlass = null,Object? weightGlass = null,Object? countPaper = null,Object? weightPaper = null,}) {
  return _then(_UserWasteStats(
countMetal: null == countMetal ? _self.countMetal : countMetal // ignore: cast_nullable_to_non_nullable
as int,weightMetal: null == weightMetal ? _self.weightMetal : weightMetal // ignore: cast_nullable_to_non_nullable
as int,countPlastic: null == countPlastic ? _self.countPlastic : countPlastic // ignore: cast_nullable_to_non_nullable
as int,weightPlastic: null == weightPlastic ? _self.weightPlastic : weightPlastic // ignore: cast_nullable_to_non_nullable
as int,countGlass: null == countGlass ? _self.countGlass : countGlass // ignore: cast_nullable_to_non_nullable
as int,weightGlass: null == weightGlass ? _self.weightGlass : weightGlass // ignore: cast_nullable_to_non_nullable
as int,countPaper: null == countPaper ? _self.countPaper : countPaper // ignore: cast_nullable_to_non_nullable
as int,weightPaper: null == weightPaper ? _self.weightPaper : weightPaper // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
