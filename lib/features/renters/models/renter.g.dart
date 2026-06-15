// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RenterDocument _$RenterDocumentFromJson(Map<String, dynamic> json) =>
    _RenterDocument(
      title: json['title'] as String,
      url: json['url'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );

Map<String, dynamic> _$RenterDocumentToJson(_RenterDocument instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
    };

_FamilyMember _$FamilyMemberFromJson(Map<String, dynamic> json) =>
    _FamilyMember(
      name: json['name'] as String,
      relation: json['relation'] as String,
      age: json['age'] as String?,
      nid: json['nid'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      occupation: json['occupation'] as String?,
      photoUrl: json['photoUrl'] as String?,
      documents:
          (json['documents'] as List<dynamic>?)
              ?.map((e) => RenterDocument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isEmergencyContact: json['isEmergencyContact'] as bool? ?? false,
    );

Map<String, dynamic> _$FamilyMemberToJson(_FamilyMember instance) =>
    <String, dynamic>{
      'name': instance.name,
      'relation': instance.relation,
      'age': instance.age,
      'nid': instance.nid,
      'phone': instance.phone,
      'email': instance.email,
      'occupation': instance.occupation,
      'photoUrl': instance.photoUrl,
      'documents': instance.documents,
      'isEmergencyContact': instance.isEmergencyContact,
    };

_Renter _$RenterFromJson(Map<String, dynamic> json) => _Renter(
  id: json['id'] as String,
  propertyId: json['propertyId'] as String,
  unitId: json['unitId'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  nid: json['nid'] as String,
  advanceDeposit: (json['advanceDeposit'] as num).toInt(),
  moveInDate: DateTime.parse(json['moveInDate'] as String),
  email: json['email'] as String?,
  occupation: json['occupation'] as String?,
  alternatePhone: json['alternatePhone'] as String?,
  photoUrl: json['photoUrl'] as String?,
  moveOutDate: json['moveOutDate'] == null
      ? null
      : DateTime.parse(json['moveOutDate'] as String),
  isActive: json['isActive'] as bool? ?? true,
  familyMembers:
      (json['familyMembers'] as List<dynamic>?)
          ?.map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  documents:
      (json['documents'] as List<dynamic>?)
          ?.map((e) => RenterDocument.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  landlordNotes: json['landlordNotes'] as String?,
);

Map<String, dynamic> _$RenterToJson(_Renter instance) => <String, dynamic>{
  'id': instance.id,
  'propertyId': instance.propertyId,
  'unitId': instance.unitId,
  'name': instance.name,
  'phone': instance.phone,
  'nid': instance.nid,
  'advanceDeposit': instance.advanceDeposit,
  'moveInDate': instance.moveInDate.toIso8601String(),
  'email': instance.email,
  'occupation': instance.occupation,
  'alternatePhone': instance.alternatePhone,
  'photoUrl': instance.photoUrl,
  'moveOutDate': instance.moveOutDate?.toIso8601String(),
  'isActive': instance.isActive,
  'familyMembers': instance.familyMembers,
  'documents': instance.documents,
  'landlordNotes': instance.landlordNotes,
};
