// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Admin {

@JsonKey(includeToJson: false) String? get email;// UserBase fields
 String? get id; String? get userName; String? get surnames; String? get phoneNumber; bool? get isActive; String? get userType; DateTime? get createdAt; bool? get isSuperadmin;
/// Create a copy of Admin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCopyWith<Admin> get copyWith => _$AdminCopyWithImpl<Admin>(this as Admin, _$identity);

  /// Serializes this Admin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Admin&&(identical(other.email, email) || other.email == email)&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isSuperadmin, isSuperadmin) || other.isSuperadmin == isSuperadmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,id,userName,surnames,phoneNumber,isActive,userType,createdAt,isSuperadmin);

@override
String toString() {
  return 'Admin(email: $email, id: $id, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, isSuperadmin: $isSuperadmin)';
}


}

/// @nodoc
abstract mixin class $AdminCopyWith<$Res>  {
  factory $AdminCopyWith(Admin value, $Res Function(Admin) _then) = _$AdminCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String? email, String? id, String? userName, String? surnames, String? phoneNumber, bool? isActive, String? userType, DateTime? createdAt, bool? isSuperadmin
});




}
/// @nodoc
class _$AdminCopyWithImpl<$Res>
    implements $AdminCopyWith<$Res> {
  _$AdminCopyWithImpl(this._self, this._then);

  final Admin _self;
  final $Res Function(Admin) _then;

/// Create a copy of Admin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? id = freezed,Object? userName = freezed,Object? surnames = freezed,Object? phoneNumber = freezed,Object? isActive = freezed,Object? userType = freezed,Object? createdAt = freezed,Object? isSuperadmin = freezed,}) {
  return _then(_self.copyWith(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,surnames: freezed == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isSuperadmin: freezed == isSuperadmin ? _self.isSuperadmin : isSuperadmin // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Admin].
extension AdminPatterns on Admin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Admin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Admin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Admin value)  $default,){
final _that = this;
switch (_that) {
case _Admin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Admin value)?  $default,){
final _that = this;
switch (_that) {
case _Admin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  bool? isSuperadmin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Admin() when $default != null:
return $default(_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.isSuperadmin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  bool? isSuperadmin)  $default,) {final _that = this;
switch (_that) {
case _Admin():
return $default(_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.isSuperadmin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String? email,  String? id,  String? userName,  String? surnames,  String? phoneNumber,  bool? isActive,  String? userType,  DateTime? createdAt,  bool? isSuperadmin)?  $default,) {final _that = this;
switch (_that) {
case _Admin() when $default != null:
return $default(_that.email,_that.id,_that.userName,_that.surnames,_that.phoneNumber,_that.isActive,_that.userType,_that.createdAt,_that.isSuperadmin);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Admin implements Admin {
  const _Admin({@JsonKey(includeToJson: false) required this.email, required this.id, required this.userName, required this.surnames, required this.phoneNumber, required this.isActive, required this.userType, required this.createdAt, required this.isSuperadmin});
  factory _Admin.fromJson(Map<String, dynamic> json) => _$AdminFromJson(json);

@override@JsonKey(includeToJson: false) final  String? email;
// UserBase fields
@override final  String? id;
@override final  String? userName;
@override final  String? surnames;
@override final  String? phoneNumber;
@override final  bool? isActive;
@override final  String? userType;
@override final  DateTime? createdAt;
@override final  bool? isSuperadmin;

/// Create a copy of Admin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCopyWith<_Admin> get copyWith => __$AdminCopyWithImpl<_Admin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Admin&&(identical(other.email, email) || other.email == email)&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.surnames, surnames) || other.surnames == surnames)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isSuperadmin, isSuperadmin) || other.isSuperadmin == isSuperadmin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,id,userName,surnames,phoneNumber,isActive,userType,createdAt,isSuperadmin);

@override
String toString() {
  return 'Admin(email: $email, id: $id, userName: $userName, surnames: $surnames, phoneNumber: $phoneNumber, isActive: $isActive, userType: $userType, createdAt: $createdAt, isSuperadmin: $isSuperadmin)';
}


}

/// @nodoc
abstract mixin class _$AdminCopyWith<$Res> implements $AdminCopyWith<$Res> {
  factory _$AdminCopyWith(_Admin value, $Res Function(_Admin) _then) = __$AdminCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String? email, String? id, String? userName, String? surnames, String? phoneNumber, bool? isActive, String? userType, DateTime? createdAt, bool? isSuperadmin
});




}
/// @nodoc
class __$AdminCopyWithImpl<$Res>
    implements _$AdminCopyWith<$Res> {
  __$AdminCopyWithImpl(this._self, this._then);

  final _Admin _self;
  final $Res Function(_Admin) _then;

/// Create a copy of Admin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? id = freezed,Object? userName = freezed,Object? surnames = freezed,Object? phoneNumber = freezed,Object? isActive = freezed,Object? userType = freezed,Object? createdAt = freezed,Object? isSuperadmin = freezed,}) {
  return _then(_Admin(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,surnames: freezed == surnames ? _self.surnames : surnames // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,userType: freezed == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isSuperadmin: freezed == isSuperadmin ? _self.isSuperadmin : isSuperadmin // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
