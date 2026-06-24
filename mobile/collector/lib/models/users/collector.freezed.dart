// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Collector {

// Validation status
// UserBase fields
 String get id; String get email; String get userName; String get surnames; String get phoneNumber; bool get isActive; String get userType; DateTime get createdAt; String? get mpAccessToken;
/// Create a copy of Collector
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectorCopyWith<Collector> get copyWith => _$CollectorCopyWithImpl<Collector>(this as Collector, _$identity);

  /// Serializes this Collector to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Collector&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mpAccessToken, mpAccessToken) || other.mpAccessToken == mpAccessToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,userName,surnames,phoneNumber,isActive,userType,createdAt,mpAccessToken);

@override
String toString() {
  return 'Collector(id: $id, email: $email, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, mpAccessToken: $mpAccessToken)';
}


}

/// @nodoc
abstract mixin class $CollectorCopyWith<$Res>  {
  factory $CollectorCopyWith(Collector value, $Res Function(Collector) _then) = _$CollectorCopyWithImpl;
@useResult
$Res call({
 String id, String email, String userName, String surnames, String phoneNumber, bool isActive, String userType, DateTime createdAt, String? mpAccessToken
});




}
/// @nodoc
class _$CollectorCopyWithImpl<$Res>
    implements $CollectorCopyWith<$Res> {
  _$CollectorCopyWithImpl(this._self, this._then);

  final Collector _self;
  final $Res Function(Collector) _then;

/// Create a copy of Collector
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? userName = null,Object? surnames = null,Object? phoneNumber = null,Object? isActive = null,Object? userType = null,Object? createdAt = null,Object? mpAccessToken = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,surnames: null == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mpAccessToken: freezed == mpAccessToken ? _self.mpAccessToken : mpAccessToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Collector].
extension CollectorPatterns on Collector {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Collector value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Collector() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Collector value)  $default,){
final _that = this;
switch (_that) {
case _Collector():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Collector value)?  $default,){
final _that = this;
switch (_that) {
case _Collector() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String userName,  String surnames,  String phoneNumber,  bool isActive,  String userType,  DateTime createdAt,  String? mpAccessToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Collector() when $default != null:
return $default(_that.id,_that.email,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.mpAccessToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String userName,  String surnames,  String phoneNumber,  bool isActive,  String userType,  DateTime createdAt,  String? mpAccessToken)  $default,) {final _that = this;
switch (_that) {
case _Collector():
return $default(_that.id,_that.email,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.mpAccessToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String userName,  String surnames,  String phoneNumber,  bool isActive,  String userType,  DateTime createdAt,  String? mpAccessToken)?  $default,) {final _that = this;
switch (_that) {
case _Collector() when $default != null:
return $default(_that.id,_that.email,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.mpAccessToken);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Collector implements Collector {
  const _Collector({required this.id, required this.email, required this.userName, required this.surnames, required this.phoneNumber, required this.isActive, required this.userType, required this.createdAt, this.mpAccessToken});
  factory _Collector.fromJson(Map<String, dynamic> json) => _$CollectorFromJson(json);

// Validation status
// UserBase fields
@override final  String id;
@override final  String email;
@override final  String userName;
@override final  String surnames;
@override final  String phoneNumber;
@override final  bool isActive;
@override final  String userType;
@override final  DateTime createdAt;
@override final  String? mpAccessToken;

/// Create a copy of Collector
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectorCopyWith<_Collector> get copyWith => __$CollectorCopyWithImpl<_Collector>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Collector&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mpAccessToken, mpAccessToken) || other.mpAccessToken == mpAccessToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,userName,surnames,phoneNumber,isActive,userType,createdAt,mpAccessToken);

@override
String toString() {
  return 'Collector(id: $id, email: $email, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, mpAccessToken: $mpAccessToken)';
}


}

/// @nodoc
abstract mixin class _$CollectorCopyWith<$Res> implements $CollectorCopyWith<$Res> {
  factory _$CollectorCopyWith(_Collector value, $Res Function(_Collector) _then) = __$CollectorCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String userName, String surnames, String phoneNumber, bool isActive, String userType, DateTime createdAt, String? mpAccessToken
});




}
/// @nodoc
class __$CollectorCopyWithImpl<$Res>
    implements _$CollectorCopyWith<$Res> {
  __$CollectorCopyWithImpl(this._self, this._then);

  final _Collector _self;
  final $Res Function(_Collector) _then;

/// Create a copy of Collector
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? userName = null,Object? surnames = null,Object? phoneNumber = null,Object? isActive = null,Object? userType = null,Object? createdAt = null,Object? mpAccessToken = freezed,}) {
  return _then(_Collector(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,surnames: null == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mpAccessToken: freezed == mpAccessToken ? _self.mpAccessToken : mpAccessToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
