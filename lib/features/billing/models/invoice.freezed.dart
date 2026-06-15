// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 int get amount; DateTime get paidAt; String? get note; List<String> get paidItems;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.paidItems, paidItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,paidAt,note,const DeepCollectionEquality().hash(paidItems));

@override
String toString() {
  return 'Payment(amount: $amount, paidAt: $paidAt, note: $note, paidItems: $paidItems)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 int amount, DateTime paidAt, String? note, List<String> paidItems
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? paidAt = null,Object? note = freezed,Object? paidItems = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,paidItems: null == paidItems ? _self.paidItems : paidItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int amount,  DateTime paidAt,  String? note,  List<String> paidItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.amount,_that.paidAt,_that.note,_that.paidItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int amount,  DateTime paidAt,  String? note,  List<String> paidItems)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.amount,_that.paidAt,_that.note,_that.paidItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int amount,  DateTime paidAt,  String? note,  List<String> paidItems)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.amount,_that.paidAt,_that.note,_that.paidItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({required this.amount, required this.paidAt, this.note, final  List<String> paidItems = const []}): _paidItems = paidItems;
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  int amount;
@override final  DateTime paidAt;
@override final  String? note;
 final  List<String> _paidItems;
@override@JsonKey() List<String> get paidItems {
  if (_paidItems is EqualUnmodifiableListView) return _paidItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paidItems);
}


/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._paidItems, _paidItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,paidAt,note,const DeepCollectionEquality().hash(_paidItems));

@override
String toString() {
  return 'Payment(amount: $amount, paidAt: $paidAt, note: $note, paidItems: $paidItems)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 int amount, DateTime paidAt, String? note, List<String> paidItems
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? paidAt = null,Object? note = freezed,Object? paidItems = null,}) {
  return _then(_Payment(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,paidItems: null == paidItems ? _self._paidItems : paidItems // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$Invoice {

 String get id; String get propertyId; String get unitId; String get monthYear; int get baseRent; Map<String, int> get utilities; int get otherCharges; int get totalAmount; String get status; List<Payment> get payments; String? get renterName; String? get renterId; DateTime? get createdAt; DateTime? get paidAt;
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceCopyWith<Invoice> get copyWith => _$InvoiceCopyWithImpl<Invoice>(this as Invoice, _$identity);

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.monthYear, monthYear) || other.monthYear == monthYear)&&(identical(other.baseRent, baseRent) || other.baseRent == baseRent)&&const DeepCollectionEquality().equals(other.utilities, utilities)&&(identical(other.otherCharges, otherCharges) || other.otherCharges == otherCharges)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.payments, payments)&&(identical(other.renterName, renterName) || other.renterName == renterName)&&(identical(other.renterId, renterId) || other.renterId == renterId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,propertyId,unitId,monthYear,baseRent,const DeepCollectionEquality().hash(utilities),otherCharges,totalAmount,status,const DeepCollectionEquality().hash(payments),renterName,renterId,createdAt,paidAt);

@override
String toString() {
  return 'Invoice(id: $id, propertyId: $propertyId, unitId: $unitId, monthYear: $monthYear, baseRent: $baseRent, utilities: $utilities, otherCharges: $otherCharges, totalAmount: $totalAmount, status: $status, payments: $payments, renterName: $renterName, renterId: $renterId, createdAt: $createdAt, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class $InvoiceCopyWith<$Res>  {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) _then) = _$InvoiceCopyWithImpl;
@useResult
$Res call({
 String id, String propertyId, String unitId, String monthYear, int baseRent, Map<String, int> utilities, int otherCharges, int totalAmount, String status, List<Payment> payments, String? renterName, String? renterId, DateTime? createdAt, DateTime? paidAt
});




}
/// @nodoc
class _$InvoiceCopyWithImpl<$Res>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._self, this._then);

  final Invoice _self;
  final $Res Function(Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? propertyId = null,Object? unitId = null,Object? monthYear = null,Object? baseRent = null,Object? utilities = null,Object? otherCharges = null,Object? totalAmount = null,Object? status = null,Object? payments = null,Object? renterName = freezed,Object? renterId = freezed,Object? createdAt = freezed,Object? paidAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,monthYear: null == monthYear ? _self.monthYear : monthYear // ignore: cast_nullable_to_non_nullable
as String,baseRent: null == baseRent ? _self.baseRent : baseRent // ignore: cast_nullable_to_non_nullable
as int,utilities: null == utilities ? _self.utilities : utilities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,otherCharges: null == otherCharges ? _self.otherCharges : otherCharges // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,renterName: freezed == renterName ? _self.renterName : renterName // ignore: cast_nullable_to_non_nullable
as String?,renterId: freezed == renterId ? _self.renterId : renterId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Invoice].
extension InvoicePatterns on Invoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invoice value)  $default,){
final _that = this;
switch (_that) {
case _Invoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invoice value)?  $default,){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String propertyId,  String unitId,  String monthYear,  int baseRent,  Map<String, int> utilities,  int otherCharges,  int totalAmount,  String status,  List<Payment> payments,  String? renterName,  String? renterId,  DateTime? createdAt,  DateTime? paidAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.propertyId,_that.unitId,_that.monthYear,_that.baseRent,_that.utilities,_that.otherCharges,_that.totalAmount,_that.status,_that.payments,_that.renterName,_that.renterId,_that.createdAt,_that.paidAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String propertyId,  String unitId,  String monthYear,  int baseRent,  Map<String, int> utilities,  int otherCharges,  int totalAmount,  String status,  List<Payment> payments,  String? renterName,  String? renterId,  DateTime? createdAt,  DateTime? paidAt)  $default,) {final _that = this;
switch (_that) {
case _Invoice():
return $default(_that.id,_that.propertyId,_that.unitId,_that.monthYear,_that.baseRent,_that.utilities,_that.otherCharges,_that.totalAmount,_that.status,_that.payments,_that.renterName,_that.renterId,_that.createdAt,_that.paidAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String propertyId,  String unitId,  String monthYear,  int baseRent,  Map<String, int> utilities,  int otherCharges,  int totalAmount,  String status,  List<Payment> payments,  String? renterName,  String? renterId,  DateTime? createdAt,  DateTime? paidAt)?  $default,) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.propertyId,_that.unitId,_that.monthYear,_that.baseRent,_that.utilities,_that.otherCharges,_that.totalAmount,_that.status,_that.payments,_that.renterName,_that.renterId,_that.createdAt,_that.paidAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invoice extends Invoice {
  const _Invoice({required this.id, required this.propertyId, required this.unitId, required this.monthYear, required this.baseRent, final  Map<String, int> utilities = const {}, required this.otherCharges, required this.totalAmount, required this.status, final  List<Payment> payments = const [], this.renterName, this.renterId, this.createdAt, this.paidAt}): _utilities = utilities,_payments = payments,super._();
  factory _Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

@override final  String id;
@override final  String propertyId;
@override final  String unitId;
@override final  String monthYear;
@override final  int baseRent;
 final  Map<String, int> _utilities;
@override@JsonKey() Map<String, int> get utilities {
  if (_utilities is EqualUnmodifiableMapView) return _utilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_utilities);
}

@override final  int otherCharges;
@override final  int totalAmount;
@override final  String status;
 final  List<Payment> _payments;
@override@JsonKey() List<Payment> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override final  String? renterName;
@override final  String? renterId;
@override final  DateTime? createdAt;
@override final  DateTime? paidAt;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceCopyWith<_Invoice> get copyWith => __$InvoiceCopyWithImpl<_Invoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.propertyId, propertyId) || other.propertyId == propertyId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.monthYear, monthYear) || other.monthYear == monthYear)&&(identical(other.baseRent, baseRent) || other.baseRent == baseRent)&&const DeepCollectionEquality().equals(other._utilities, _utilities)&&(identical(other.otherCharges, otherCharges) || other.otherCharges == otherCharges)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._payments, _payments)&&(identical(other.renterName, renterName) || other.renterName == renterName)&&(identical(other.renterId, renterId) || other.renterId == renterId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,propertyId,unitId,monthYear,baseRent,const DeepCollectionEquality().hash(_utilities),otherCharges,totalAmount,status,const DeepCollectionEquality().hash(_payments),renterName,renterId,createdAt,paidAt);

@override
String toString() {
  return 'Invoice(id: $id, propertyId: $propertyId, unitId: $unitId, monthYear: $monthYear, baseRent: $baseRent, utilities: $utilities, otherCharges: $otherCharges, totalAmount: $totalAmount, status: $status, payments: $payments, renterName: $renterName, renterId: $renterId, createdAt: $createdAt, paidAt: $paidAt)';
}


}

/// @nodoc
abstract mixin class _$InvoiceCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$InvoiceCopyWith(_Invoice value, $Res Function(_Invoice) _then) = __$InvoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String propertyId, String unitId, String monthYear, int baseRent, Map<String, int> utilities, int otherCharges, int totalAmount, String status, List<Payment> payments, String? renterName, String? renterId, DateTime? createdAt, DateTime? paidAt
});




}
/// @nodoc
class __$InvoiceCopyWithImpl<$Res>
    implements _$InvoiceCopyWith<$Res> {
  __$InvoiceCopyWithImpl(this._self, this._then);

  final _Invoice _self;
  final $Res Function(_Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? propertyId = null,Object? unitId = null,Object? monthYear = null,Object? baseRent = null,Object? utilities = null,Object? otherCharges = null,Object? totalAmount = null,Object? status = null,Object? payments = null,Object? renterName = freezed,Object? renterId = freezed,Object? createdAt = freezed,Object? paidAt = freezed,}) {
  return _then(_Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,propertyId: null == propertyId ? _self.propertyId : propertyId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,monthYear: null == monthYear ? _self.monthYear : monthYear // ignore: cast_nullable_to_non_nullable
as String,baseRent: null == baseRent ? _self.baseRent : baseRent // ignore: cast_nullable_to_non_nullable
as int,utilities: null == utilities ? _self._utilities : utilities // ignore: cast_nullable_to_non_nullable
as Map<String, int>,otherCharges: null == otherCharges ? _self.otherCharges : otherCharges // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<Payment>,renterName: freezed == renterName ? _self.renterName : renterName // ignore: cast_nullable_to_non_nullable
as String?,renterId: freezed == renterId ? _self.renterId : renterId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
