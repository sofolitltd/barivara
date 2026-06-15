// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rent_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RentPost {

 String? get id; String get unitId; String get propertyId; String get landlordId; String get title; String get description; String get location; int get rentAmount; List<String> get imageUrls; DateTime get createdAt; bool get isActive; String? get propertyType; int? get beds; int? get baths; String? get areaSqft;
/// Create a copy of RentPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentPostCopyWith<RentPost> get copyWith => _$RentPostCopyWithImpl<RentPost>(this as RentPost, _$identity);

  /// Serializes this RentPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentPost&&(identical(other.id, id) || other.id == id)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.landlordId, landlordId) || other.landlordId == landlordId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.rentAmount, rentAmount) || other.rentAmount == rentAmount)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.beds, beds) || other.beds == beds)&&(identical(other.baths, baths) || other.baths == baths)&&(identical(other.areaSqft, areaSqft) || other.areaSqft == areaSqft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,unitId,propertyId,landlordId,title,description,location,rentAmount,const DeepCollectionEquality().hash(imageUrls),createdAt,isActive,propertyType,beds,baths,areaSqft);

@override
String toString() {
  return 'RentPost(id: $id, unitId: $unitId, propertyId: $propertyId, landlordId: $landlordId, title: $title, description: $description, location: $location, rentAmount: $rentAmount, imageUrls: $imageUrls, createdAt: $createdAt, isActive: $isActive, propertyType: $propertyType, beds: $beds, baths: $baths, areaSqft: $areaSqft)';
}


}

/// @nodoc
abstract mixin class $RentPostCopyWith<$Res>  {
  factory $RentPostCopyWith(RentPost value, $Res Function(RentPost) _then) = _$RentPostCopyWithImpl;
@useResult
$Res call({
 String? id, String unitId, String propertyId, String landlordId, String title, String description, String location, int rentAmount, List<String> imageUrls, DateTime createdAt, bool isActive, String? propertyType, int? beds, int? baths, String? areaSqft
});




}
/// @nodoc
class _$RentPostCopyWithImpl<$Res>
    implements $RentPostCopyWith<$Res> {
  _$RentPostCopyWithImpl(this._self, this._then);

  final RentPost _self;
  final $Res Function(RentPost) _then;

/// Create a copy of RentPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? unitId = null,Object? propertyId = null,Object? landlordId = null,Object? title = null,Object? description = null,Object? location = null,Object? rentAmount = null,Object? imageUrls = null,Object? createdAt = null,Object? isActive = null,Object? propertyType = freezed,Object? beds = freezed,Object? baths = freezed,Object? areaSqft = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,landlordId: null == landlordId ? _self.landlordId : landlordId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,rentAmount: null == rentAmount ? _self.rentAmount : rentAmount // ignore: cast_nullable_to_non_nullable
as int,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,propertyType: freezed == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as String?,beds: freezed == beds ? _self.beds : beds // ignore: cast_nullable_to_non_nullable
as int?,baths: freezed == baths ? _self.baths : baths // ignore: cast_nullable_to_non_nullable
as int?,areaSqft: freezed == areaSqft ? _self.areaSqft : areaSqft // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RentPost].
extension RentPostPatterns on RentPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentPost value)  $default,){
final _that = this;
switch (_that) {
case _RentPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentPost value)?  $default,){
final _that = this;
switch (_that) {
case _RentPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String unitId,  String propertyId,  String landlordId,  String title,  String description,  String location,  int rentAmount,  List<String> imageUrls,  DateTime createdAt,  bool isActive,  String? propertyType,  int? beds,  int? baths,  String? areaSqft)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentPost() when $default != null:
return $default(_that.id,_that.unitId,_that.propertyId,_that.landlordId,_that.title,_that.description,_that.location,_that.rentAmount,_that.imageUrls,_that.createdAt,_that.isActive,_that.propertyType,_that.beds,_that.baths,_that.areaSqft);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String unitId,  String propertyId,  String landlordId,  String title,  String description,  String location,  int rentAmount,  List<String> imageUrls,  DateTime createdAt,  bool isActive,  String? propertyType,  int? beds,  int? baths,  String? areaSqft)  $default,) {final _that = this;
switch (_that) {
case _RentPost():
return $default(_that.id,_that.unitId,_that.propertyId,_that.landlordId,_that.title,_that.description,_that.location,_that.rentAmount,_that.imageUrls,_that.createdAt,_that.isActive,_that.propertyType,_that.beds,_that.baths,_that.areaSqft);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String unitId,  String propertyId,  String landlordId,  String title,  String description,  String location,  int rentAmount,  List<String> imageUrls,  DateTime createdAt,  bool isActive,  String? propertyType,  int? beds,  int? baths,  String? areaSqft)?  $default,) {final _that = this;
switch (_that) {
case _RentPost() when $default != null:
return $default(_that.id,_that.unitId,_that.propertyId,_that.landlordId,_that.title,_that.description,_that.location,_that.rentAmount,_that.imageUrls,_that.createdAt,_that.isActive,_that.propertyType,_that.beds,_that.baths,_that.areaSqft);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentPost extends RentPost {
  const _RentPost({this.id, required this.unitId, required this.propertyId, required this.landlordId, required this.title, required this.description, required this.location, required this.rentAmount, final  List<String> imageUrls = const [], required this.createdAt, this.isActive = true, this.propertyType, this.beds, this.baths, this.areaSqft}): _imageUrls = imageUrls,super._();
  factory _RentPost.fromJson(Map<String, dynamic> json) => _$RentPostFromJson(json);

@override final  String? id;
@override final  String unitId;
@override final  String propertyId;
@override final  String landlordId;
@override final  String title;
@override final  String description;
@override final  String location;
@override final  int rentAmount;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  DateTime createdAt;
@override@JsonKey() final  bool isActive;
@override final  String? propertyType;
@override final  int? beds;
@override final  int? baths;
@override final  String? areaSqft;

/// Create a copy of RentPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentPostCopyWith<_RentPost> get copyWith => __$RentPostCopyWithImpl<_RentPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentPost&&(identical(other.id, id) || other.id == id)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.landlordId, landlordId) || other.landlordId == landlordId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.rentAmount, rentAmount) || other.rentAmount == rentAmount)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.beds, beds) || other.beds == beds)&&(identical(other.baths, baths) || other.baths == baths)&&(identical(other.areaSqft, areaSqft) || other.areaSqft == areaSqft));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,unitId,propertyId,landlordId,title,description,location,rentAmount,const DeepCollectionEquality().hash(_imageUrls),createdAt,isActive,propertyType,beds,baths,areaSqft);

@override
String toString() {
  return 'RentPost(id: $id, unitId: $unitId, propertyId: $propertyId, landlordId: $landlordId, title: $title, description: $description, location: $location, rentAmount: $rentAmount, imageUrls: $imageUrls, createdAt: $createdAt, isActive: $isActive, propertyType: $propertyType, beds: $beds, baths: $baths, areaSqft: $areaSqft)';
}


}

/// @nodoc
abstract mixin class _$RentPostCopyWith<$Res> implements $RentPostCopyWith<$Res> {
  factory _$RentPostCopyWith(_RentPost value, $Res Function(_RentPost) _then) = __$RentPostCopyWithImpl;
@override @useResult
$Res call({
 String? id, String unitId, String propertyId, String landlordId, String title, String description, String location, int rentAmount, List<String> imageUrls, DateTime createdAt, bool isActive, String? propertyType, int? beds, int? baths, String? areaSqft
});




}
/// @nodoc
class __$RentPostCopyWithImpl<$Res>
    implements _$RentPostCopyWith<$Res> {
  __$RentPostCopyWithImpl(this._self, this._then);

  final _RentPost _self;
  final $Res Function(_RentPost) _then;

/// Create a copy of RentPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? unitId = null,Object? propertyId = null,Object? landlordId = null,Object? title = null,Object? description = null,Object? location = null,Object? rentAmount = null,Object? imageUrls = null,Object? createdAt = null,Object? isActive = null,Object? propertyType = freezed,Object? beds = freezed,Object? baths = freezed,Object? areaSqft = freezed,}) {
  return _then(_RentPost(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,landlordId: null == landlordId ? _self.landlordId : landlordId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,rentAmount: null == rentAmount ? _self.rentAmount : rentAmount // ignore: cast_nullable_to_non_nullable
as int,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,propertyType: freezed == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as String?,beds: freezed == beds ? _self.beds : beds // ignore: cast_nullable_to_non_nullable
as int?,baths: freezed == baths ? _self.baths : baths // ignore: cast_nullable_to_non_nullable
as int?,areaSqft: freezed == areaSqft ? _self.areaSqft : areaSqft // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
