// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landlord_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LandlordRequest {

 String? get id; String get userId; String get userName; String get phone; String get nidNumber; String get ownerProofImageUrl; String get status;// 'pending', 'approved', 'rejected'
 DateTime get createdAt;
/// Create a copy of LandlordRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LandlordRequestCopyWith<LandlordRequest> get copyWith => _$LandlordRequestCopyWithImpl<LandlordRequest>(this as LandlordRequest, _$identity);

  /// Serializes this LandlordRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LandlordRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nidNumber, nidNumber) || other.nidNumber == nidNumber)&&(identical(other.ownerProofImageUrl, ownerProofImageUrl) || other.ownerProofImageUrl == ownerProofImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,phone,nidNumber,ownerProofImageUrl,status,createdAt);

@override
String toString() {
  return 'LandlordRequest(id: $id, userId: $userId, userName: $userName, phone: $phone, nidNumber: $nidNumber, ownerProofImageUrl: $ownerProofImageUrl, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LandlordRequestCopyWith<$Res>  {
  factory $LandlordRequestCopyWith(LandlordRequest value, $Res Function(LandlordRequest) _then) = _$LandlordRequestCopyWithImpl;
@useResult
$Res call({
 String? id, String userId, String userName, String phone, String nidNumber, String ownerProofImageUrl, String status, DateTime createdAt
});




}
/// @nodoc
class _$LandlordRequestCopyWithImpl<$Res>
    implements $LandlordRequestCopyWith<$Res> {
  _$LandlordRequestCopyWithImpl(this._self, this._then);

  final LandlordRequest _self;
  final $Res Function(LandlordRequest) _then;

/// Create a copy of LandlordRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? userName = null,Object? phone = null,Object? nidNumber = null,Object? ownerProofImageUrl = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,nidNumber: null == nidNumber ? _self.nidNumber : nidNumber // ignore: cast_nullable_to_non_nullable
as String,ownerProofImageUrl: null == ownerProofImageUrl ? _self.ownerProofImageUrl : ownerProofImageUrl // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LandlordRequest].
extension LandlordRequestPatterns on LandlordRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LandlordRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LandlordRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LandlordRequest value)  $default,){
final _that = this;
switch (_that) {
case _LandlordRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LandlordRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LandlordRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String userId,  String userName,  String phone,  String nidNumber,  String ownerProofImageUrl,  String status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LandlordRequest() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.phone,_that.nidNumber,_that.ownerProofImageUrl,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String userId,  String userName,  String phone,  String nidNumber,  String ownerProofImageUrl,  String status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LandlordRequest():
return $default(_that.id,_that.userId,_that.userName,_that.phone,_that.nidNumber,_that.ownerProofImageUrl,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String userId,  String userName,  String phone,  String nidNumber,  String ownerProofImageUrl,  String status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LandlordRequest() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.phone,_that.nidNumber,_that.ownerProofImageUrl,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LandlordRequest implements LandlordRequest {
  const _LandlordRequest({this.id, required this.userId, required this.userName, required this.phone, required this.nidNumber, required this.ownerProofImageUrl, this.status = 'pending', required this.createdAt});
  factory _LandlordRequest.fromJson(Map<String, dynamic> json) => _$LandlordRequestFromJson(json);

@override final  String? id;
@override final  String userId;
@override final  String userName;
@override final  String phone;
@override final  String nidNumber;
@override final  String ownerProofImageUrl;
@override@JsonKey() final  String status;
// 'pending', 'approved', 'rejected'
@override final  DateTime createdAt;

/// Create a copy of LandlordRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LandlordRequestCopyWith<_LandlordRequest> get copyWith => __$LandlordRequestCopyWithImpl<_LandlordRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LandlordRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LandlordRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nidNumber, nidNumber) || other.nidNumber == nidNumber)&&(identical(other.ownerProofImageUrl, ownerProofImageUrl) || other.ownerProofImageUrl == ownerProofImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,phone,nidNumber,ownerProofImageUrl,status,createdAt);

@override
String toString() {
  return 'LandlordRequest(id: $id, userId: $userId, userName: $userName, phone: $phone, nidNumber: $nidNumber, ownerProofImageUrl: $ownerProofImageUrl, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LandlordRequestCopyWith<$Res> implements $LandlordRequestCopyWith<$Res> {
  factory _$LandlordRequestCopyWith(_LandlordRequest value, $Res Function(_LandlordRequest) _then) = __$LandlordRequestCopyWithImpl;
@override @useResult
$Res call({
 String? id, String userId, String userName, String phone, String nidNumber, String ownerProofImageUrl, String status, DateTime createdAt
});




}
/// @nodoc
class __$LandlordRequestCopyWithImpl<$Res>
    implements _$LandlordRequestCopyWith<$Res> {
  __$LandlordRequestCopyWithImpl(this._self, this._then);

  final _LandlordRequest _self;
  final $Res Function(_LandlordRequest) _then;

/// Create a copy of LandlordRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? userName = null,Object? phone = null,Object? nidNumber = null,Object? ownerProofImageUrl = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_LandlordRequest(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,nidNumber: null == nidNumber ? _self.nidNumber : nidNumber // ignore: cast_nullable_to_non_nullable
as String,ownerProofImageUrl: null == ownerProofImageUrl ? _self.ownerProofImageUrl : ownerProofImageUrl // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
