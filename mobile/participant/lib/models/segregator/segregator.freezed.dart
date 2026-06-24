// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'segregator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Segregator {

 int get id; double? get latitude; double? get longitude;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'payload_qr') String? get payloadQr; String? get description;// Niveles de llenado
 List<BinModel> get bins;
/// Create a copy of Segregator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SegregatorCopyWith<Segregator> get copyWith => _$SegregatorCopyWithImpl<Segregator>(this as Segregator, _$identity);

  /// Serializes this Segregator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Segregator&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.payloadQr, payloadQr) || other.payloadQr == payloadQr)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.bins, bins));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,latitude,longitude,isActive,payloadQr,description,const DeepCollectionEquality().hash(bins));

@override
String toString() {
  return 'Segregator(id: $id, latitude: $latitude, longitude: $longitude, isActive: $isActive, payloadQr: $payloadQr, description: $description, bins: $bins)';
}


}

/// @nodoc
abstract mixin class $SegregatorCopyWith<$Res>  {
  factory $SegregatorCopyWith(Segregator value, $Res Function(Segregator) _then) = _$SegregatorCopyWithImpl;
@useResult
$Res call({
 int id, double? latitude, double? longitude,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'payload_qr') String? payloadQr, String? description, List<BinModel> bins
});




}
/// @nodoc
class _$SegregatorCopyWithImpl<$Res>
    implements $SegregatorCopyWith<$Res> {
  _$SegregatorCopyWithImpl(this._self, this._then);

  final Segregator _self;
  final $Res Function(Segregator) _then;

/// Create a copy of Segregator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? latitude = freezed,Object? longitude = freezed,Object? isActive = null,Object? payloadQr = freezed,Object? description = freezed,Object? bins = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,payloadQr: freezed == payloadQr ? _self.payloadQr : payloadQr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,bins: null == bins ? _self.bins : bins // ignore: cast_nullable_to_non_nullable
as List<BinModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [Segregator].
extension SegregatorPatterns on Segregator {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Segregator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Segregator() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Segregator value)  $default,){
final _that = this;
switch (_that) {
case _Segregator():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Segregator value)?  $default,){
final _that = this;
switch (_that) {
case _Segregator() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  double? latitude,  double? longitude, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'payload_qr')  String? payloadQr,  String? description,  List<BinModel> bins)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Segregator() when $default != null:
return $default(_that.id,_that.latitude,_that.longitude,_that.isActive,_that.payloadQr,_that.description,_that.bins);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  double? latitude,  double? longitude, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'payload_qr')  String? payloadQr,  String? description,  List<BinModel> bins)  $default,) {final _that = this;
switch (_that) {
case _Segregator():
return $default(_that.id,_that.latitude,_that.longitude,_that.isActive,_that.payloadQr,_that.description,_that.bins);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  double? latitude,  double? longitude, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'payload_qr')  String? payloadQr,  String? description,  List<BinModel> bins)?  $default,) {final _that = this;
switch (_that) {
case _Segregator() when $default != null:
return $default(_that.id,_that.latitude,_that.longitude,_that.isActive,_that.payloadQr,_that.description,_that.bins);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Segregator implements Segregator {
  const _Segregator({required this.id, required this.latitude, required this.longitude, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'payload_qr') this.payloadQr, required this.description, required final  List<BinModel> bins}): _bins = bins;
  factory _Segregator.fromJson(Map<String, dynamic> json) => _$SegregatorFromJson(json);

@override final  int id;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'payload_qr') final  String? payloadQr;
@override final  String? description;
// Niveles de llenado
 final  List<BinModel> _bins;
// Niveles de llenado
@override List<BinModel> get bins {
  if (_bins is EqualUnmodifiableListView) return _bins;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bins);
}


/// Create a copy of Segregator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SegregatorCopyWith<_Segregator> get copyWith => __$SegregatorCopyWithImpl<_Segregator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SegregatorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Segregator&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.payloadQr, payloadQr) || other.payloadQr == payloadQr)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._bins, _bins));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,latitude,longitude,isActive,payloadQr,description,const DeepCollectionEquality().hash(_bins));

@override
String toString() {
  return 'Segregator(id: $id, latitude: $latitude, longitude: $longitude, isActive: $isActive, payloadQr: $payloadQr, description: $description, bins: $bins)';
}


}

/// @nodoc
abstract mixin class _$SegregatorCopyWith<$Res> implements $SegregatorCopyWith<$Res> {
  factory _$SegregatorCopyWith(_Segregator value, $Res Function(_Segregator) _then) = __$SegregatorCopyWithImpl;
@override @useResult
$Res call({
 int id, double? latitude, double? longitude,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'payload_qr') String? payloadQr, String? description, List<BinModel> bins
});




}
/// @nodoc
class __$SegregatorCopyWithImpl<$Res>
    implements _$SegregatorCopyWith<$Res> {
  __$SegregatorCopyWithImpl(this._self, this._then);

  final _Segregator _self;
  final $Res Function(_Segregator) _then;

/// Create a copy of Segregator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? latitude = freezed,Object? longitude = freezed,Object? isActive = null,Object? payloadQr = freezed,Object? description = freezed,Object? bins = null,}) {
  return _then(_Segregator(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,payloadQr: freezed == payloadQr ? _self.payloadQr : payloadQr // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,bins: null == bins ? _self._bins : bins // ignore: cast_nullable_to_non_nullable
as List<BinModel>,
  ));
}


}

// dart format on
