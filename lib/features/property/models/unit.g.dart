// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RentConfig _$RentConfigFromJson(Map<String, dynamic> json) => _RentConfig(
  amount: (json['amount'] as num).toInt(),
  startDate: DateTime.parse(json['startDate'] as String),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$RentConfigToJson(_RentConfig instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'startDate': instance.startDate.toIso8601String(),
      'reason': instance.reason,
    };

_DepositConfig _$DepositConfigFromJson(Map<String, dynamic> json) =>
    _DepositConfig(
      amount: (json['amount'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$DepositConfigToJson(_DepositConfig instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'startDate': instance.startDate.toIso8601String(),
      'reason': instance.reason,
    };

_Unit _$UnitFromJson(Map<String, dynamic> json) => _Unit(
  id: json['id'] as String,
  propertyId: json['propertyId'] as String,
  unitNumber: json['unitNumber'] as String,
  baseRent: (json['baseRent'] as num).toInt(),
  isOccupied: json['isOccupied'] as bool? ?? false,
  defaultUtilities:
      (json['defaultUtilities'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
  rentHistory:
      (json['rentHistory'] as List<dynamic>?)
          ?.map((e) => RentConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  depositHistory:
      (json['depositHistory'] as List<dynamic>?)
          ?.map((e) => DepositConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  floorLevel: (json['floorLevel'] as num?)?.toInt(),
  unitSize: json['unitSize'] as String?,
  unitType: json['unitType'] as String?,
  securityDeposit: (json['securityDeposit'] as num?)?.toInt(),
  status: json['status'] as String? ?? 'vacant',
  meters:
      (json['meters'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  imageUrl: json['imageUrl'] as String?,
  videoUrl: json['videoUrl'] as String?,
);

Map<String, dynamic> _$UnitToJson(_Unit instance) => <String, dynamic>{
  'id': instance.id,
  'propertyId': instance.propertyId,
  'unitNumber': instance.unitNumber,
  'baseRent': instance.baseRent,
  'isOccupied': instance.isOccupied,
  'defaultUtilities': instance.defaultUtilities,
  'rentHistory': instance.rentHistory,
  'depositHistory': instance.depositHistory,
  'floorLevel': instance.floorLevel,
  'unitSize': instance.unitSize,
  'unitType': instance.unitType,
  'securityDeposit': instance.securityDeposit,
  'status': instance.status,
  'meters': instance.meters,
  'imageUrl': instance.imageUrl,
  'videoUrl': instance.videoUrl,
};
