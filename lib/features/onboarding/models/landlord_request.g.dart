// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landlord_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LandlordRequest _$LandlordRequestFromJson(Map<String, dynamic> json) =>
    _LandlordRequest(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      phone: json['phone'] as String,
      nidNumber: json['nidNumber'] as String,
      ownerProofImageUrl: json['ownerProofImageUrl'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$LandlordRequestToJson(_LandlordRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'phone': instance.phone,
      'nidNumber': instance.nidNumber,
      'ownerProofImageUrl': instance.ownerProofImageUrl,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
