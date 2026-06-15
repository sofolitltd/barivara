// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'renter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RenterDocument {

 String get title; String get url; DateTime get uploadedAt;
/// Create a copy of RenterDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenterDocumentCopyWith<RenterDocument> get copyWith => _$RenterDocumentCopyWithImpl<RenterDocument>(this as RenterDocument, _$identity);

  /// Serializes this RenterDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenterDocument&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,uploadedAt);

@override
String toString() {
  return 'RenterDocument(title: $title, url: $url, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class $RenterDocumentCopyWith<$Res>  {
  factory $RenterDocumentCopyWith(RenterDocument value, $Res Function(RenterDocument) _then) = _$RenterDocumentCopyWithImpl;
@useResult
$Res call({
 String title, String url, DateTime uploadedAt
});




}
/// @nodoc
class _$RenterDocumentCopyWithImpl<$Res>
    implements $RenterDocumentCopyWith<$Res> {
  _$RenterDocumentCopyWithImpl(this._self, this._then);

  final RenterDocument _self;
  final $Res Function(RenterDocument) _then;

/// Create a copy of RenterDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? url = null,Object? uploadedAt = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RenterDocument].
extension RenterDocumentPatterns on RenterDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenterDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenterDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenterDocument value)  $default,){
final _that = this;
switch (_that) {
case _RenterDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenterDocument value)?  $default,){
final _that = this;
switch (_that) {
case _RenterDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String url,  DateTime uploadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenterDocument() when $default != null:
return $default(_that.title,_that.url,_that.uploadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String url,  DateTime uploadedAt)  $default,) {final _that = this;
switch (_that) {
case _RenterDocument():
return $default(_that.title,_that.url,_that.uploadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String url,  DateTime uploadedAt)?  $default,) {final _that = this;
switch (_that) {
case _RenterDocument() when $default != null:
return $default(_that.title,_that.url,_that.uploadedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenterDocument implements RenterDocument {
  const _RenterDocument({required this.title, required this.url, required this.uploadedAt});
  factory _RenterDocument.fromJson(Map<String, dynamic> json) => _$RenterDocumentFromJson(json);

@override final  String title;
@override final  String url;
@override final  DateTime uploadedAt;

/// Create a copy of RenterDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenterDocumentCopyWith<_RenterDocument> get copyWith => __$RenterDocumentCopyWithImpl<_RenterDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenterDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenterDocument&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,uploadedAt);

@override
String toString() {
  return 'RenterDocument(title: $title, url: $url, uploadedAt: $uploadedAt)';
}


}

/// @nodoc
abstract mixin class _$RenterDocumentCopyWith<$Res> implements $RenterDocumentCopyWith<$Res> {
  factory _$RenterDocumentCopyWith(_RenterDocument value, $Res Function(_RenterDocument) _then) = __$RenterDocumentCopyWithImpl;
@override @useResult
$Res call({
 String title, String url, DateTime uploadedAt
});




}
/// @nodoc
class __$RenterDocumentCopyWithImpl<$Res>
    implements _$RenterDocumentCopyWith<$Res> {
  __$RenterDocumentCopyWithImpl(this._self, this._then);

  final _RenterDocument _self;
  final $Res Function(_RenterDocument) _then;

/// Create a copy of RenterDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? url = null,Object? uploadedAt = null,}) {
  return _then(_RenterDocument(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FamilyMember {

 String get name; String get relation; String? get age; String? get nid; String? get phone; String? get email; String? get occupation; String? get photoUrl; List<RenterDocument> get documents; bool get isEmergencyContact;
/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyMemberCopyWith<FamilyMember> get copyWith => _$FamilyMemberCopyWithImpl<FamilyMember>(this as FamilyMember, _$identity);

  /// Serializes this FamilyMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyMember&&(identical(other.name, name) || other.name == name)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.age, age) || other.age == age)&&(identical(other.nid, nid) || other.nid == nid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&const DeepCollectionEquality().equals(other.documents, documents)&&(identical(other.isEmergencyContact, isEmergencyContact) || other.isEmergencyContact == isEmergencyContact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,relation,age,nid,phone,email,occupation,photoUrl,const DeepCollectionEquality().hash(documents),isEmergencyContact);

@override
String toString() {
  return 'FamilyMember(name: $name, relation: $relation, age: $age, nid: $nid, phone: $phone, email: $email, occupation: $occupation, photoUrl: $photoUrl, documents: $documents, isEmergencyContact: $isEmergencyContact)';
}


}

/// @nodoc
abstract mixin class $FamilyMemberCopyWith<$Res>  {
  factory $FamilyMemberCopyWith(FamilyMember value, $Res Function(FamilyMember) _then) = _$FamilyMemberCopyWithImpl;
@useResult
$Res call({
 String name, String relation, String? age, String? nid, String? phone, String? email, String? occupation, String? photoUrl, List<RenterDocument> documents, bool isEmergencyContact
});




}
/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._self, this._then);

  final FamilyMember _self;
  final $Res Function(FamilyMember) _then;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? relation = null,Object? age = freezed,Object? nid = freezed,Object? phone = freezed,Object? email = freezed,Object? occupation = freezed,Object? photoUrl = freezed,Object? documents = null,Object? isEmergencyContact = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String?,nid: freezed == nid ? _self.nid : nid // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as List<RenterDocument>,isEmergencyContact: null == isEmergencyContact ? _self.isEmergencyContact : isEmergencyContact // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyMember].
extension FamilyMemberPatterns on FamilyMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyMember value)  $default,){
final _that = this;
switch (_that) {
case _FamilyMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyMember value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String relation,  String? age,  String? nid,  String? phone,  String? email,  String? occupation,  String? photoUrl,  List<RenterDocument> documents,  bool isEmergencyContact)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
return $default(_that.name,_that.relation,_that.age,_that.nid,_that.phone,_that.email,_that.occupation,_that.photoUrl,_that.documents,_that.isEmergencyContact);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String relation,  String? age,  String? nid,  String? phone,  String? email,  String? occupation,  String? photoUrl,  List<RenterDocument> documents,  bool isEmergencyContact)  $default,) {final _that = this;
switch (_that) {
case _FamilyMember():
return $default(_that.name,_that.relation,_that.age,_that.nid,_that.phone,_that.email,_that.occupation,_that.photoUrl,_that.documents,_that.isEmergencyContact);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String relation,  String? age,  String? nid,  String? phone,  String? email,  String? occupation,  String? photoUrl,  List<RenterDocument> documents,  bool isEmergencyContact)?  $default,) {final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
return $default(_that.name,_that.relation,_that.age,_that.nid,_that.phone,_that.email,_that.occupation,_that.photoUrl,_that.documents,_that.isEmergencyContact);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FamilyMember extends FamilyMember {
  const _FamilyMember({required this.name, required this.relation, this.age, this.nid, this.phone, this.email, this.occupation, this.photoUrl, final  List<RenterDocument> documents = const [], this.isEmergencyContact = false}): _documents = documents,super._();
  factory _FamilyMember.fromJson(Map<String, dynamic> json) => _$FamilyMemberFromJson(json);

@override final  String name;
@override final  String relation;
@override final  String? age;
@override final  String? nid;
@override final  String? phone;
@override final  String? email;
@override final  String? occupation;
@override final  String? photoUrl;
 final  List<RenterDocument> _documents;
@override@JsonKey() List<RenterDocument> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}

@override@JsonKey() final  bool isEmergencyContact;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyMemberCopyWith<_FamilyMember> get copyWith => __$FamilyMemberCopyWithImpl<_FamilyMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyMember&&(identical(other.name, name) || other.name == name)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.age, age) || other.age == age)&&(identical(other.nid, nid) || other.nid == nid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&const DeepCollectionEquality().equals(other._documents, _documents)&&(identical(other.isEmergencyContact, isEmergencyContact) || other.isEmergencyContact == isEmergencyContact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,relation,age,nid,phone,email,occupation,photoUrl,const DeepCollectionEquality().hash(_documents),isEmergencyContact);

@override
String toString() {
  return 'FamilyMember(name: $name, relation: $relation, age: $age, nid: $nid, phone: $phone, email: $email, occupation: $occupation, photoUrl: $photoUrl, documents: $documents, isEmergencyContact: $isEmergencyContact)';
}


}

/// @nodoc
abstract mixin class _$FamilyMemberCopyWith<$Res> implements $FamilyMemberCopyWith<$Res> {
  factory _$FamilyMemberCopyWith(_FamilyMember value, $Res Function(_FamilyMember) _then) = __$FamilyMemberCopyWithImpl;
@override @useResult
$Res call({
 String name, String relation, String? age, String? nid, String? phone, String? email, String? occupation, String? photoUrl, List<RenterDocument> documents, bool isEmergencyContact
});




}
/// @nodoc
class __$FamilyMemberCopyWithImpl<$Res>
    implements _$FamilyMemberCopyWith<$Res> {
  __$FamilyMemberCopyWithImpl(this._self, this._then);

  final _FamilyMember _self;
  final $Res Function(_FamilyMember) _then;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? relation = null,Object? age = freezed,Object? nid = freezed,Object? phone = freezed,Object? email = freezed,Object? occupation = freezed,Object? photoUrl = freezed,Object? documents = null,Object? isEmergencyContact = null,}) {
  return _then(_FamilyMember(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String?,nid: freezed == nid ? _self.nid : nid // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<RenterDocument>,isEmergencyContact: null == isEmergencyContact ? _self.isEmergencyContact : isEmergencyContact // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$Renter {

 String get id; String get propertyId; String get unitId; String get name; String get phone; String get nid; int get advanceDeposit; DateTime get moveInDate; String? get email; String? get occupation; String? get alternatePhone; String? get photoUrl; DateTime? get moveOutDate; bool get isActive; List<FamilyMember> get familyMembers; List<RenterDocument> get documents; String? get landlordNotes;
/// Create a copy of Renter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenterCopyWith<Renter> get copyWith => _$RenterCopyWithImpl<Renter>(this as Renter, _$identity);

  /// Serializes this Renter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Renter&&(identical(other.id, id) || other.id == id)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nid, nid) || other.nid == nid)&&(identical(other.advanceDeposit, advanceDeposit) || other.advanceDeposit == advanceDeposit)&&(identical(other.moveInDate, moveInDate) || other.moveInDate == moveInDate)&&(identical(other.email, email) || other.email == email)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.alternatePhone, alternatePhone) || other.alternatePhone == alternatePhone)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.moveOutDate, moveOutDate) || other.moveOutDate == moveOutDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.familyMembers, familyMembers)&&const DeepCollectionEquality().equals(other.documents, documents)&&(identical(other.landlordNotes, landlordNotes) || other.landlordNotes == landlordNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,propertyId,unitId,name,phone,nid,advanceDeposit,moveInDate,email,occupation,alternatePhone,photoUrl,moveOutDate,isActive,const DeepCollectionEquality().hash(familyMembers),const DeepCollectionEquality().hash(documents),landlordNotes);

@override
String toString() {
  return 'Renter(id: $id, propertyId: $propertyId, unitId: $unitId, name: $name, phone: $phone, nid: $nid, advanceDeposit: $advanceDeposit, moveInDate: $moveInDate, email: $email, occupation: $occupation, alternatePhone: $alternatePhone, photoUrl: $photoUrl, moveOutDate: $moveOutDate, isActive: $isActive, familyMembers: $familyMembers, documents: $documents, landlordNotes: $landlordNotes)';
}


}

/// @nodoc
abstract mixin class $RenterCopyWith<$Res>  {
  factory $RenterCopyWith(Renter value, $Res Function(Renter) _then) = _$RenterCopyWithImpl;
@useResult
$Res call({
 String id, String propertyId, String unitId, String name, String phone, String nid, int advanceDeposit, DateTime moveInDate, String? email, String? occupation, String? alternatePhone, String? photoUrl, DateTime? moveOutDate, bool isActive, List<FamilyMember> familyMembers, List<RenterDocument> documents, String? landlordNotes
});




}
/// @nodoc
class _$RenterCopyWithImpl<$Res>
    implements $RenterCopyWith<$Res> {
  _$RenterCopyWithImpl(this._self, this._then);

  final Renter _self;
  final $Res Function(Renter) _then;

/// Create a copy of Renter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? propertyId = null,Object? unitId = null,Object? name = null,Object? phone = null,Object? nid = null,Object? advanceDeposit = null,Object? moveInDate = null,Object? email = freezed,Object? occupation = freezed,Object? alternatePhone = freezed,Object? photoUrl = freezed,Object? moveOutDate = freezed,Object? isActive = null,Object? familyMembers = null,Object? documents = null,Object? landlordNotes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,nid: null == nid ? _self.nid : nid // ignore: cast_nullable_to_non_nullable
as String,advanceDeposit: null == advanceDeposit ? _self.advanceDeposit : advanceDeposit // ignore: cast_nullable_to_non_nullable
as int,moveInDate: null == moveInDate ? _self.moveInDate : moveInDate // ignore: cast_nullable_to_non_nullable
as DateTime,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,alternatePhone: freezed == alternatePhone ? _self.alternatePhone : alternatePhone // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,moveOutDate: freezed == moveOutDate ? _self.moveOutDate : moveOutDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,familyMembers: null == familyMembers ? _self.familyMembers : familyMembers // ignore: cast_nullable_to_non_nullable
as List<FamilyMember>,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as List<RenterDocument>,landlordNotes: freezed == landlordNotes ? _self.landlordNotes : landlordNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Renter].
extension RenterPatterns on Renter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Renter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Renter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Renter value)  $default,){
final _that = this;
switch (_that) {
case _Renter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Renter value)?  $default,){
final _that = this;
switch (_that) {
case _Renter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String propertyId,  String unitId,  String name,  String phone,  String nid,  int advanceDeposit,  DateTime moveInDate,  String? email,  String? occupation,  String? alternatePhone,  String? photoUrl,  DateTime? moveOutDate,  bool isActive,  List<FamilyMember> familyMembers,  List<RenterDocument> documents,  String? landlordNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Renter() when $default != null:
return $default(_that.id,_that.propertyId,_that.unitId,_that.name,_that.phone,_that.nid,_that.advanceDeposit,_that.moveInDate,_that.email,_that.occupation,_that.alternatePhone,_that.photoUrl,_that.moveOutDate,_that.isActive,_that.familyMembers,_that.documents,_that.landlordNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String propertyId,  String unitId,  String name,  String phone,  String nid,  int advanceDeposit,  DateTime moveInDate,  String? email,  String? occupation,  String? alternatePhone,  String? photoUrl,  DateTime? moveOutDate,  bool isActive,  List<FamilyMember> familyMembers,  List<RenterDocument> documents,  String? landlordNotes)  $default,) {final _that = this;
switch (_that) {
case _Renter():
return $default(_that.id,_that.propertyId,_that.unitId,_that.name,_that.phone,_that.nid,_that.advanceDeposit,_that.moveInDate,_that.email,_that.occupation,_that.alternatePhone,_that.photoUrl,_that.moveOutDate,_that.isActive,_that.familyMembers,_that.documents,_that.landlordNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String propertyId,  String unitId,  String name,  String phone,  String nid,  int advanceDeposit,  DateTime moveInDate,  String? email,  String? occupation,  String? alternatePhone,  String? photoUrl,  DateTime? moveOutDate,  bool isActive,  List<FamilyMember> familyMembers,  List<RenterDocument> documents,  String? landlordNotes)?  $default,) {final _that = this;
switch (_that) {
case _Renter() when $default != null:
return $default(_that.id,_that.propertyId,_that.unitId,_that.name,_that.phone,_that.nid,_that.advanceDeposit,_that.moveInDate,_that.email,_that.occupation,_that.alternatePhone,_that.photoUrl,_that.moveOutDate,_that.isActive,_that.familyMembers,_that.documents,_that.landlordNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Renter extends Renter {
  const _Renter({required this.id, required this.propertyId, required this.unitId, required this.name, required this.phone, required this.nid, required this.advanceDeposit, required this.moveInDate, this.email, this.occupation, this.alternatePhone, this.photoUrl, this.moveOutDate, this.isActive = true, final  List<FamilyMember> familyMembers = const [], final  List<RenterDocument> documents = const [], this.landlordNotes}): _familyMembers = familyMembers,_documents = documents,super._();
  factory _Renter.fromJson(Map<String, dynamic> json) => _$RenterFromJson(json);

@override final  String id;
@override final  String propertyId;
@override final  String unitId;
@override final  String name;
@override final  String phone;
@override final  String nid;
@override final  int advanceDeposit;
@override final  DateTime moveInDate;
@override final  String? email;
@override final  String? occupation;
@override final  String? alternatePhone;
@override final  String? photoUrl;
@override final  DateTime? moveOutDate;
@override@JsonKey() final  bool isActive;
 final  List<FamilyMember> _familyMembers;
@override@JsonKey() List<FamilyMember> get familyMembers {
  if (_familyMembers is EqualUnmodifiableListView) return _familyMembers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_familyMembers);
}

 final  List<RenterDocument> _documents;
@override@JsonKey() List<RenterDocument> get documents {
  if (_documents is EqualUnmodifiableListView) return _documents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documents);
}

@override final  String? landlordNotes;

/// Create a copy of Renter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenterCopyWith<_Renter> get copyWith => __$RenterCopyWithImpl<_Renter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Renter&&(identical(other.id, id) || other.id == id)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nid, nid) || other.nid == nid)&&(identical(other.advanceDeposit, advanceDeposit) || other.advanceDeposit == advanceDeposit)&&(identical(other.moveInDate, moveInDate) || other.moveInDate == moveInDate)&&(identical(other.email, email) || other.email == email)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.alternatePhone, alternatePhone) || other.alternatePhone == alternatePhone)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.moveOutDate, moveOutDate) || other.moveOutDate == moveOutDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._familyMembers, _familyMembers)&&const DeepCollectionEquality().equals(other._documents, _documents)&&(identical(other.landlordNotes, landlordNotes) || other.landlordNotes == landlordNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,propertyId,unitId,name,phone,nid,advanceDeposit,moveInDate,email,occupation,alternatePhone,photoUrl,moveOutDate,isActive,const DeepCollectionEquality().hash(_familyMembers),const DeepCollectionEquality().hash(_documents),landlordNotes);

@override
String toString() {
  return 'Renter(id: $id, propertyId: $propertyId, unitId: $unitId, name: $name, phone: $phone, nid: $nid, advanceDeposit: $advanceDeposit, moveInDate: $moveInDate, email: $email, occupation: $occupation, alternatePhone: $alternatePhone, photoUrl: $photoUrl, moveOutDate: $moveOutDate, isActive: $isActive, familyMembers: $familyMembers, documents: $documents, landlordNotes: $landlordNotes)';
}


}

/// @nodoc
abstract mixin class _$RenterCopyWith<$Res> implements $RenterCopyWith<$Res> {
  factory _$RenterCopyWith(_Renter value, $Res Function(_Renter) _then) = __$RenterCopyWithImpl;
@override @useResult
$Res call({
 String id, String propertyId, String unitId, String name, String phone, String nid, int advanceDeposit, DateTime moveInDate, String? email, String? occupation, String? alternatePhone, String? photoUrl, DateTime? moveOutDate, bool isActive, List<FamilyMember> familyMembers, List<RenterDocument> documents, String? landlordNotes
});




}
/// @nodoc
class __$RenterCopyWithImpl<$Res>
    implements _$RenterCopyWith<$Res> {
  __$RenterCopyWithImpl(this._self, this._then);

  final _Renter _self;
  final $Res Function(_Renter) _then;

/// Create a copy of Renter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? propertyId = null,Object? unitId = null,Object? name = null,Object? phone = null,Object? nid = null,Object? advanceDeposit = null,Object? moveInDate = null,Object? email = freezed,Object? occupation = freezed,Object? alternatePhone = freezed,Object? photoUrl = freezed,Object? moveOutDate = freezed,Object? isActive = null,Object? familyMembers = null,Object? documents = null,Object? landlordNotes = freezed,}) {
  return _then(_Renter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,nid: null == nid ? _self.nid : nid // ignore: cast_nullable_to_non_nullable
as String,advanceDeposit: null == advanceDeposit ? _self.advanceDeposit : advanceDeposit // ignore: cast_nullable_to_non_nullable
as int,moveInDate: null == moveInDate ? _self.moveInDate : moveInDate // ignore: cast_nullable_to_non_nullable
as DateTime,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,occupation: freezed == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String?,alternatePhone: freezed == alternatePhone ? _self.alternatePhone : alternatePhone // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,moveOutDate: freezed == moveOutDate ? _self.moveOutDate : moveOutDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,familyMembers: null == familyMembers ? _self._familyMembers : familyMembers // ignore: cast_nullable_to_non_nullable
as List<FamilyMember>,documents: null == documents ? _self._documents : documents // ignore: cast_nullable_to_non_nullable
as List<RenterDocument>,landlordNotes: freezed == landlordNotes ? _self.landlordNotes : landlordNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
