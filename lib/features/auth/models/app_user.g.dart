// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: json['uid'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String? ?? 'renter',
  status: json['status'] as String? ?? 'none',
  plan: json['plan'] as String? ?? 'free',
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'status': instance.status,
  'plan': instance.plan,
  'photoUrl': instance.photoUrl,
};
