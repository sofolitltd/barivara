// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RentConfig {

 int get amount; DateTime get startDate; String? get reason;
/// Create a copy of RentConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentConfigCopyWith<RentConfig> get copyWith => _$RentConfigCopyWithImpl<RentConfig>(this as RentConfig, _$identity);

  /// Serializes this RentConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentConfig&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,startDate,reason);

@override
String toString() {
  return 'RentConfig(amount: $amount, startDate: $startDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $RentConfigCopyWith<$Res>  {
  factory $RentConfigCopyWith(RentConfig value, $Res Function(RentConfig) _then) = _$RentConfigCopyWithImpl;
@useResult
$Res call({
 int amount, DateTime startDate, String? reason
});




}
/// @nodoc
class _$RentConfigCopyWithImpl<$Res>
    implements $RentConfigCopyWith<$Res> {
  _$RentConfigCopyWithImpl(this._self, this._then);

  final RentConfig _self;
  final $Res Function(RentConfig) _then;

/// Create a copy of RentConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? startDate = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RentConfig].
extension RentConfigPatterns on RentConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentConfig value)  $default,){
final _that = this;
switch (_that) {
case _RentConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RentConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amount,  DateTime startDate,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentConfig() when $default != null:
return $default(_that.amount,_that.startDate,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amount,  DateTime startDate,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _RentConfig():
return $default(_that.amount,_that.startDate,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amount,  DateTime startDate,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _RentConfig() when $default != null:
return $default(_that.amount,_that.startDate,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentConfig implements RentConfig {
  const _RentConfig({required this.amount, required this.startDate, this.reason});
  factory _RentConfig.fromJson(Map<String, dynamic> json) => _$RentConfigFromJson(json);

@override final  int amount;
@override final  DateTime startDate;
@override final  String? reason;

/// Create a copy of RentConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentConfigCopyWith<_RentConfig> get copyWith => __$RentConfigCopyWithImpl<_RentConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentConfig&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,startDate,reason);

@override
String toString() {
  return 'RentConfig(amount: $amount, startDate: $startDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$RentConfigCopyWith<$Res> implements $RentConfigCopyWith<$Res> {
  factory _$RentConfigCopyWith(_RentConfig value, $Res Function(_RentConfig) _then) = __$RentConfigCopyWithImpl;
@override @useResult
$Res call({
 int amount, DateTime startDate, String? reason
});




}
/// @nodoc
class __$RentConfigCopyWithImpl<$Res>
    implements _$RentConfigCopyWith<$Res> {
  __$RentConfigCopyWithImpl(this._self, this._then);

  final _RentConfig _self;
  final $Res Function(_RentConfig) _then;

/// Create a copy of RentConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? startDate = null,Object? reason = freezed,}) {
  return _then(_RentConfig(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DepositConfig {

 int get amount; DateTime get startDate; String? get reason;
/// Create a copy of DepositConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepositConfigCopyWith<DepositConfig> get copyWith => _$DepositConfigCopyWithImpl<DepositConfig>(this as DepositConfig, _$identity);

  /// Serializes this DepositConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepositConfig&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,startDate,reason);

@override
String toString() {
  return 'DepositConfig(amount: $amount, startDate: $startDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $DepositConfigCopyWith<$Res>  {
  factory $DepositConfigCopyWith(DepositConfig value, $Res Function(DepositConfig) _then) = _$DepositConfigCopyWithImpl;
@useResult
$Res call({
 int amount, DateTime startDate, String? reason
});




}
/// @nodoc
class _$DepositConfigCopyWithImpl<$Res>
    implements $DepositConfigCopyWith<$Res> {
  _$DepositConfigCopyWithImpl(this._self, this._then);

  final DepositConfig _self;
  final $Res Function(DepositConfig) _then;

/// Create a copy of DepositConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? startDate = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DepositConfig].
extension DepositConfigPatterns on DepositConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepositConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepositConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepositConfig value)  $default,){
final _that = this;
switch (_that) {
case _DepositConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepositConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DepositConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amount,  DateTime startDate,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepositConfig() when $default != null:
return $default(_that.amount,_that.startDate,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amount,  DateTime startDate,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _DepositConfig():
return $default(_that.amount,_that.startDate,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amount,  DateTime startDate,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _DepositConfig() when $default != null:
return $default(_that.amount,_that.startDate,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepositConfig implements DepositConfig {
  const _DepositConfig({required this.amount, required this.startDate, this.reason});
  factory _DepositConfig.fromJson(Map<String, dynamic> json) => _$DepositConfigFromJson(json);

@override final  int amount;
@override final  DateTime startDate;
@override final  String? reason;

/// Create a copy of DepositConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepositConfigCopyWith<_DepositConfig> get copyWith => __$DepositConfigCopyWithImpl<_DepositConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepositConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepositConfig&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,startDate,reason);

@override
String toString() {
  return 'DepositConfig(amount: $amount, startDate: $startDate, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$DepositConfigCopyWith<$Res> implements $DepositConfigCopyWith<$Res> {
  factory _$DepositConfigCopyWith(_DepositConfig value, $Res Function(_DepositConfig) _then) = __$DepositConfigCopyWithImpl;
@override @useResult
$Res call({
 int amount, DateTime startDate, String? reason
});




}
/// @nodoc
class __$DepositConfigCopyWithImpl<$Res>
    implements _$DepositConfigCopyWith<$Res> {
  __$DepositConfigCopyWithImpl(this._self, this._then);

  final _DepositConfig _self;
  final $Res Function(_DepositConfig) _then;

/// Create a copy of DepositConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? startDate = null,Object? reason = freezed,}) {
  return _then(_DepositConfig(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Unit {

 String get id; String get propertyId; String get unitNumber; int get baseRent; bool get isOccupied; Map<String, int> get defaultUtilities; List<RentConfig> get rentHistory; List<DepositConfig> get depositHistory; int? get floorLevel; String? get unitSize; String? get unitType; int? get securityDeposit; String get status; Map<String, String> get meters; String? get imageUrl; String? get videoUrl;
/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitCopyWith<Unit> get copyWith => _$UnitCopyWithImpl<Unit>(this as Unit, _$identity);

  /// Serializes this Unit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unit&&(identical(other.id, id) || other.id == id)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.unitNumber, unitNumber) || other.unitNumber == unitNumber)&&(identical(other.baseRent, baseRent) || other.baseRent == baseRent)&&(identical(other.isOccupied, isOccupied) || other.isOccupied == isOccupied)&&const DeepCollectionEquality().equals(other.defaultUtilities, defaultUtilities)&&const DeepCollectionEquality().equals(other.rentHistory, rentHistory)&&const DeepCollectionEquality().equals(other.depositHistory, depositHistory)&&(identical(other.floorLevel, floorLevel) || other.floorLevel == floorLevel)&&(identical(other.unitSize, unitSize) || other.unitSize == unitSize)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.securityDeposit, securityDeposit) || other.securityDeposit == securityDeposit)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.meters, meters)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,propertyId,unitNumber,baseRent,isOccupied,const DeepCollectionEquality().hash(defaultUtilities),const DeepCollectionEquality().hash(rentHistory),const DeepCollectionEquality().hash(depositHistory),floorLevel,unitSize,unitType,securityDeposit,status,const DeepCollectionEquality().hash(meters),imageUrl,videoUrl);

@override
String toString() {
  return 'Unit(id: $id, propertyId: $propertyId, unitNumber: $unitNumber, baseRent: $baseRent, isOccupied: $isOccupied, defaultUtilities: $defaultUtilities, rentHistory: $rentHistory, depositHistory: $depositHistory, floorLevel: $floorLevel, unitSize: $unitSize, unitType: $unitType, securityDeposit: $securityDeposit, status: $status, meters: $meters, imageUrl: $imageUrl, videoUrl: $videoUrl)';
}


}

/// @nodoc
abstract mixin class $UnitCopyWith<$Res>  {
  factory $UnitCopyWith(Unit value, $Res Function(Unit) _then) = _$UnitCopyWithImpl;
@useResult
$Res call({
 String id, String propertyId, String unitNumber, int baseRent, bool isOccupied, Map<String, int> defaultUtilities, List<RentConfig> rentHistory, List<DepositConfig> depositHistory, int? floorLevel, String? unitSize, String? unitType, int? securityDeposit, String status, Map<String, String> meters, String? imageUrl, String? videoUrl
});




}
/// @nodoc
class _$UnitCopyWithImpl<$Res>
    implements $UnitCopyWith<$Res> {
  _$UnitCopyWithImpl(this._self, this._then);

  final Unit _self;
  final $Res Function(Unit) _then;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? propertyId = null,Object? unitNumber = null,Object? baseRent = null,Object? isOccupied = null,Object? defaultUtilities = null,Object? rentHistory = null,Object? depositHistory = null,Object? floorLevel = freezed,Object? unitSize = freezed,Object? unitType = freezed,Object? securityDeposit = freezed,Object? status = null,Object? meters = null,Object? imageUrl = freezed,Object? videoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,unitNumber: null == unitNumber ? _self.unitNumber : unitNumber // ignore: cast_nullable_to_non_nullable
as String,baseRent: null == baseRent ? _self.baseRent : baseRent // ignore: cast_nullable_to_non_nullable
as int,isOccupied: null == isOccupied ? _self.isOccupied : isOccupied // ignore: cast_nullable_to_non_nullable
as bool,defaultUtilities: null == defaultUtilities ? _self.defaultUtilities : defaultUtilities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,rentHistory: null == rentHistory ? _self.rentHistory : rentHistory // ignore: cast_nullable_to_non_nullable
as List<RentConfig>,depositHistory: null == depositHistory ? _self.depositHistory : depositHistory // ignore: cast_nullable_to_non_nullable
as List<DepositConfig>,floorLevel: freezed == floorLevel ? _self.floorLevel : floorLevel // ignore: cast_nullable_to_non_nullable
as int?,unitSize: freezed == unitSize ? _self.unitSize : unitSize // ignore: cast_nullable_to_non_nullable
as String?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,securityDeposit: freezed == securityDeposit ? _self.securityDeposit : securityDeposit // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,meters: null == meters ? _self.meters : meters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Unit].
extension UnitPatterns on Unit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Unit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Unit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Unit value)  $default,){
final _that = this;
switch (_that) {
case _Unit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Unit value)?  $default,){
final _that = this;
switch (_that) {
case _Unit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String propertyId,  String unitNumber,  int baseRent,  bool isOccupied,  Map<String, int> defaultUtilities,  List<RentConfig> rentHistory,  List<DepositConfig> depositHistory,  int? floorLevel,  String? unitSize,  String? unitType,  int? securityDeposit,  String status,  Map<String, String> meters,  String? imageUrl,  String? videoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that.id,_that.propertyId,_that.unitNumber,_that.baseRent,_that.isOccupied,_that.defaultUtilities,_that.rentHistory,_that.depositHistory,_that.floorLevel,_that.unitSize,_that.unitType,_that.securityDeposit,_that.status,_that.meters,_that.imageUrl,_that.videoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String propertyId,  String unitNumber,  int baseRent,  bool isOccupied,  Map<String, int> defaultUtilities,  List<RentConfig> rentHistory,  List<DepositConfig> depositHistory,  int? floorLevel,  String? unitSize,  String? unitType,  int? securityDeposit,  String status,  Map<String, String> meters,  String? imageUrl,  String? videoUrl)  $default,) {final _that = this;
switch (_that) {
case _Unit():
return $default(_that.id,_that.propertyId,_that.unitNumber,_that.baseRent,_that.isOccupied,_that.defaultUtilities,_that.rentHistory,_that.depositHistory,_that.floorLevel,_that.unitSize,_that.unitType,_that.securityDeposit,_that.status,_that.meters,_that.imageUrl,_that.videoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String propertyId,  String unitNumber,  int baseRent,  bool isOccupied,  Map<String, int> defaultUtilities,  List<RentConfig> rentHistory,  List<DepositConfig> depositHistory,  int? floorLevel,  String? unitSize,  String? unitType,  int? securityDeposit,  String status,  Map<String, String> meters,  String? imageUrl,  String? videoUrl)?  $default,) {final _that = this;
switch (_that) {
case _Unit() when $default != null:
return $default(_that.id,_that.propertyId,_that.unitNumber,_that.baseRent,_that.isOccupied,_that.defaultUtilities,_that.rentHistory,_that.depositHistory,_that.floorLevel,_that.unitSize,_that.unitType,_that.securityDeposit,_that.status,_that.meters,_that.imageUrl,_that.videoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Unit extends Unit {
  const _Unit({required this.id, required this.propertyId, required this.unitNumber, required this.baseRent, this.isOccupied = false, final  Map<String, int> defaultUtilities = const {}, final  List<RentConfig> rentHistory = const [], final  List<DepositConfig> depositHistory = const [], this.floorLevel, this.unitSize, this.unitType, this.securityDeposit, this.status = 'vacant', final  Map<String, String> meters = const {}, this.imageUrl, this.videoUrl}): _defaultUtilities = defaultUtilities,_rentHistory = rentHistory,_depositHistory = depositHistory,_meters = meters,super._();
  factory _Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

@override final  String id;
@override final  String propertyId;
@override final  String unitNumber;
@override final  int baseRent;
@override@JsonKey() final  bool isOccupied;
 final  Map<String, int> _defaultUtilities;
@override@JsonKey() Map<String, int> get defaultUtilities {
  if (_defaultUtilities is EqualUnmodifiableMapView) return _defaultUtilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_defaultUtilities);
}

 final  List<RentConfig> _rentHistory;
@override@JsonKey() List<RentConfig> get rentHistory {
  if (_rentHistory is EqualUnmodifiableListView) return _rentHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rentHistory);
}

 final  List<DepositConfig> _depositHistory;
@override@JsonKey() List<DepositConfig> get depositHistory {
  if (_depositHistory is EqualUnmodifiableListView) return _depositHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_depositHistory);
}

@override final  int? floorLevel;
@override final  String? unitSize;
@override final  String? unitType;
@override final  int? securityDeposit;
@override@JsonKey() final  String status;
 final  Map<String, String> _meters;
@override@JsonKey() Map<String, String> get meters {
  if (_meters is EqualUnmodifiableMapView) return _meters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_meters);
}

@override final  String? imageUrl;
@override final  String? videoUrl;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitCopyWith<_Unit> get copyWith => __$UnitCopyWithImpl<_Unit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unit&&(identical(other.id, id) || other.id == id)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.unitNumber, unitNumber) || other.unitNumber == unitNumber)&&(identical(other.baseRent, baseRent) || other.baseRent == baseRent)&&(identical(other.isOccupied, isOccupied) || other.isOccupied == isOccupied)&&const DeepCollectionEquality().equals(other._defaultUtilities, _defaultUtilities)&&const DeepCollectionEquality().equals(other._rentHistory, _rentHistory)&&const DeepCollectionEquality().equals(other._depositHistory, _depositHistory)&&(identical(other.floorLevel, floorLevel) || other.floorLevel == floorLevel)&&(identical(other.unitSize, unitSize) || other.unitSize == unitSize)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.securityDeposit, securityDeposit) || other.securityDeposit == securityDeposit)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._meters, _meters)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,propertyId,unitNumber,baseRent,isOccupied,const DeepCollectionEquality().hash(_defaultUtilities),const DeepCollectionEquality().hash(_rentHistory),const DeepCollectionEquality().hash(_depositHistory),floorLevel,unitSize,unitType,securityDeposit,status,const DeepCollectionEquality().hash(_meters),imageUrl,videoUrl);

@override
String toString() {
  return 'Unit(id: $id, propertyId: $propertyId, unitNumber: $unitNumber, baseRent: $baseRent, isOccupied: $isOccupied, defaultUtilities: $defaultUtilities, rentHistory: $rentHistory, depositHistory: $depositHistory, floorLevel: $floorLevel, unitSize: $unitSize, unitType: $unitType, securityDeposit: $securityDeposit, status: $status, meters: $meters, imageUrl: $imageUrl, videoUrl: $videoUrl)';
}


}

/// @nodoc
abstract mixin class _$UnitCopyWith<$Res> implements $UnitCopyWith<$Res> {
  factory _$UnitCopyWith(_Unit value, $Res Function(_Unit) _then) = __$UnitCopyWithImpl;
@override @useResult
$Res call({
 String id, String propertyId, String unitNumber, int baseRent, bool isOccupied, Map<String, int> defaultUtilities, List<RentConfig> rentHistory, List<DepositConfig> depositHistory, int? floorLevel, String? unitSize, String? unitType, int? securityDeposit, String status, Map<String, String> meters, String? imageUrl, String? videoUrl
});




}
/// @nodoc
class __$UnitCopyWithImpl<$Res>
    implements _$UnitCopyWith<$Res> {
  __$UnitCopyWithImpl(this._self, this._then);

  final _Unit _self;
  final $Res Function(_Unit) _then;

/// Create a copy of Unit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? propertyId = null,Object? unitNumber = null,Object? baseRent = null,Object? isOccupied = null,Object? defaultUtilities = null,Object? rentHistory = null,Object? depositHistory = null,Object? floorLevel = freezed,Object? unitSize = freezed,Object? unitType = freezed,Object? securityDeposit = freezed,Object? status = null,Object? meters = null,Object? imageUrl = freezed,Object? videoUrl = freezed,}) {
  return _then(_Unit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,unitNumber: null == unitNumber ? _self.unitNumber : unitNumber // ignore: cast_nullable_to_non_nullable
as String,baseRent: null == baseRent ? _self.baseRent : baseRent // ignore: cast_nullable_to_non_nullable
as int,isOccupied: null == isOccupied ? _self.isOccupied : isOccupied // ignore: cast_nullable_to_non_nullable
as bool,defaultUtilities: null == defaultUtilities ? _self._defaultUtilities : defaultUtilities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,rentHistory: null == rentHistory ? _self._rentHistory : rentHistory // ignore: cast_nullable_to_non_nullable
as List<RentConfig>,depositHistory: null == depositHistory ? _self._depositHistory : depositHistory // ignore: cast_nullable_to_non_nullable
as List<DepositConfig>,floorLevel: freezed == floorLevel ? _self.floorLevel : floorLevel // ignore: cast_nullable_to_non_nullable
as int?,unitSize: freezed == unitSize ? _self.unitSize : unitSize // ignore: cast_nullable_to_non_nullable
as String?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,securityDeposit: freezed == securityDeposit ? _self.securityDeposit : securityDeposit // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,meters: null == meters ? _self._meters : meters // ignore: cast_nullable_to_non_nullable
as Map<String, String>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
