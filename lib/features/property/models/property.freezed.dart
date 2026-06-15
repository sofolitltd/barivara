// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Property {

 String get id; String get ownerId; String get name; String get address; String? get googleMapsUrl; String? get propertyType; String? get imageUrl; String? get videoUrl;
/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyCopyWith<Property> get copyWith => _$PropertyCopyWithImpl<Property>(this as Property, _$identity);

  /// Serializes this Property to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Property&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.googleMapsUrl, googleMapsUrl) || other.googleMapsUrl == googleMapsUrl)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,address,googleMapsUrl,propertyType,imageUrl,videoUrl);

@override
String toString() {
  return 'Property(id: $id, ownerId: $ownerId, name: $name, address: $address, googleMapsUrl: $googleMapsUrl, propertyType: $propertyType, imageUrl: $imageUrl, videoUrl: $videoUrl)';
}


}

/// @nodoc
abstract mixin class $PropertyCopyWith<$Res>  {
  factory $PropertyCopyWith(Property value, $Res Function(Property) _then) = _$PropertyCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String name, String address, String? googleMapsUrl, String? propertyType, String? imageUrl, String? videoUrl
});




}
/// @nodoc
class _$PropertyCopyWithImpl<$Res>
    implements $PropertyCopyWith<$Res> {
  _$PropertyCopyWithImpl(this._self, this._then);

  final Property _self;
  final $Res Function(Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? address = null,Object? googleMapsUrl = freezed,Object? propertyType = freezed,Object? imageUrl = freezed,Object? videoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,googleMapsUrl: freezed == googleMapsUrl ? _self.googleMapsUrl : googleMapsUrl // ignore: cast_nullable_to_non_nullable
as String?,propertyType: freezed == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Property].
extension PropertyPatterns on Property {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Property value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Property() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Property value)  $default,){
final _that = this;
switch (_that) {
case _Property():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Property value)?  $default,){
final _that = this;
switch (_that) {
case _Property() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String address,  String? googleMapsUrl,  String? propertyType,  String? imageUrl,  String? videoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.googleMapsUrl,_that.propertyType,_that.imageUrl,_that.videoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String address,  String? googleMapsUrl,  String? propertyType,  String? imageUrl,  String? videoUrl)  $default,) {final _that = this;
switch (_that) {
case _Property():
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.googleMapsUrl,_that.propertyType,_that.imageUrl,_that.videoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String name,  String address,  String? googleMapsUrl,  String? propertyType,  String? imageUrl,  String? videoUrl)?  $default,) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.address,_that.googleMapsUrl,_that.propertyType,_that.imageUrl,_that.videoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Property extends Property {
  const _Property({required this.id, required this.ownerId, required this.name, required this.address, this.googleMapsUrl, this.propertyType, this.imageUrl, this.videoUrl}): super._();
  factory _Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

@override final  String id;
@override final  String ownerId;
@override final  String name;
@override final  String address;
@override final  String? googleMapsUrl;
@override final  String? propertyType;
@override final  String? imageUrl;
@override final  String? videoUrl;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyCopyWith<_Property> get copyWith => __$PropertyCopyWithImpl<_Property>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Property&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.googleMapsUrl, googleMapsUrl) || other.googleMapsUrl == googleMapsUrl)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,address,googleMapsUrl,propertyType,imageUrl,videoUrl);

@override
String toString() {
  return 'Property(id: $id, ownerId: $ownerId, name: $name, address: $address, googleMapsUrl: $googleMapsUrl, propertyType: $propertyType, imageUrl: $imageUrl, videoUrl: $videoUrl)';
}


}

/// @nodoc
abstract mixin class _$PropertyCopyWith<$Res> implements $PropertyCopyWith<$Res> {
  factory _$PropertyCopyWith(_Property value, $Res Function(_Property) _then) = __$PropertyCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String name, String address, String? googleMapsUrl, String? propertyType, String? imageUrl, String? videoUrl
});




}
/// @nodoc
class __$PropertyCopyWithImpl<$Res>
    implements _$PropertyCopyWith<$Res> {
  __$PropertyCopyWithImpl(this._self, this._then);

  final _Property _self;
  final $Res Function(_Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? address = null,Object? googleMapsUrl = freezed,Object? propertyType = freezed,Object? imageUrl = freezed,Object? videoUrl = freezed,}) {
  return _then(_Property(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,googleMapsUrl: freezed == googleMapsUrl ? _self.googleMapsUrl : googleMapsUrl // ignore: cast_nullable_to_non_nullable
as String?,propertyType: freezed == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
