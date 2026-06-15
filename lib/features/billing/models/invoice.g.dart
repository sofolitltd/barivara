// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  amount: (json['amount'] as num).toInt(),
  paidAt: DateTime.parse(json['paidAt'] as String),
  note: json['note'] as String?,
  paidItems:
      (json['paidItems'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'amount': instance.amount,
  'paidAt': instance.paidAt.toIso8601String(),
  'note': instance.note,
  'paidItems': instance.paidItems,
};

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: json['id'] as String,
  propertyId: json['propertyId'] as String,
  unitId: json['unitId'] as String,
  monthYear: json['monthYear'] as String,
  baseRent: (json['baseRent'] as num).toInt(),
  utilities:
      (json['utilities'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  otherCharges: (json['otherCharges'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toInt(),
  status: json['status'] as String,
  invoiceNumber: json['invoiceNumber'] as String? ?? '',
  payments:
      (json['payments'] as List<dynamic>?)
          ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  renterName: json['renterName'] as String?,
  renterId: json['renterId'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  'id': instance.id,
  'propertyId': instance.propertyId,
  'unitId': instance.unitId,
  'monthYear': instance.monthYear,
  'baseRent': instance.baseRent,
  'utilities': instance.utilities,
  'otherCharges': instance.otherCharges,
  'totalAmount': instance.totalAmount,
  'status': instance.status,
  'invoiceNumber': instance.invoiceNumber,
  'payments': instance.payments,
  'renterName': instance.renterName,
  'renterId': instance.renterId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'paidAt': instance.paidAt?.toIso8601String(),
};
