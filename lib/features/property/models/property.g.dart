// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Property _$PropertyFromJson(Map<String, dynamic> json) => _Property(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  googleMapsUrl: json['googleMapsUrl'] as String?,
  propertyType: json['propertyType'] as String?,
  imageUrl: json['imageUrl'] as String?,
  videoUrl: json['videoUrl'] as String?,
);

Map<String, dynamic> _$PropertyToJson(_Property instance) => <String, dynamic>{
  'id': instance.id,
  'ownerId': instance.ownerId,
  'name': instance.name,
  'address': instance.address,
  'googleMapsUrl': instance.googleMapsUrl,
  'propertyType': instance.propertyType,
  'imageUrl': instance.imageUrl,
  'videoUrl': instance.videoUrl,
};
