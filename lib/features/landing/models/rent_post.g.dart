// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RentPost _$RentPostFromJson(Map<String, dynamic> json) => _RentPost(
  id: json['id'] as String?,
  unitId: json['unitId'] as String,
  propertyId: json['propertyId'] as String,
  landlordId: json['landlordId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  rentAmount: (json['rentAmount'] as num).toInt(),
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  isActive: json['isActive'] as bool? ?? true,
  propertyType: json['propertyType'] as String?,
  beds: (json['beds'] as num?)?.toInt(),
  baths: (json['baths'] as num?)?.toInt(),
  areaSqft: json['areaSqft'] as String?,
);

Map<String, dynamic> _$RentPostToJson(_RentPost instance) => <String, dynamic>{
  'id': instance.id,
  'unitId': instance.unitId,
  'propertyId': instance.propertyId,
  'landlordId': instance.landlordId,
  'title': instance.title,
  'description': instance.description,
  'location': instance.location,
  'rentAmount': instance.rentAmount,
  'imageUrls': instance.imageUrls,
  'createdAt': instance.createdAt.toIso8601String(),
  'isActive': instance.isActive,
  'propertyType': instance.propertyType,
  'beds': instance.beds,
  'baths': instance.baths,
  'areaSqft': instance.areaSqft,
};
