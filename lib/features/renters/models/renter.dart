import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'renter.freezed.dart';
part 'renter.g.dart';

@freezed
abstract class RenterDocument with _$RenterDocument {
  const factory RenterDocument({
    required String title,
    required String url,
    required DateTime uploadedAt,
  }) = _RenterDocument;

  factory RenterDocument.fromJson(Map<String, dynamic> json) =>
      _$RenterDocumentFromJson(json);
}

@freezed
abstract class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String name,
    required String relation,
    String? age,
    String? nid,
    String? phone,
    String? email,
    String? occupation,
    String? photoUrl,
    @Default([]) List<RenterDocument> documents,
    @Default(false) bool isEmergencyContact,
  }) = _FamilyMember;

  const FamilyMember._();

  factory FamilyMember.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberFromJson(json);

  Map<String, dynamic> toDocument() => {
        'name': name,
        'relation': relation,
        'age': age,
        'nid': nid,
        'phone': phone,
        'email': email,
        'occupation': occupation,
        'photoUrl': photoUrl,
        'documents': documents.map((d) => d.toJson()).toList(),
        'isEmergencyContact': isEmergencyContact,
      };
}

@freezed
abstract class Renter with _$Renter {
  const factory Renter({
    required String id,
    required String propertyId,
    required String unitId,
    required String name,
    required String phone,
    required String nid,
    required int advanceDeposit,
    required DateTime moveInDate,
    String? email,
    String? occupation,
    String? alternatePhone,
    String? photoUrl,
    DateTime? moveOutDate,
    @Default(true) bool isActive,
    @Default([]) List<FamilyMember> familyMembers,
    @Default([]) List<RenterDocument> documents,
    String? landlordNotes,
  }) = _Renter;

  const Renter._();

  factory Renter.fromJson(Map<String, dynamic> json) => _$RenterFromJson(json);

  factory Renter.fromDocument(Map<String, dynamic> docData, String docId) {
    final data = Map<String, dynamic>.from(docData);
    if (data['moveInDate'] is Timestamp) {
      data['moveInDate'] =
          (data['moveInDate'] as Timestamp).toDate().toIso8601String();
    }
    if (data['moveOutDate'] is Timestamp) {
      data['moveOutDate'] =
          (data['moveOutDate'] as Timestamp).toDate().toIso8601String();
    }
    return Renter.fromJson(data).copyWith(id: docId);
  }

  Map<String, dynamic> toDocument() => {
        'id': id,
        'propertyId': propertyId,
        'unitId': unitId,
        'name': name,
        'phone': phone,
        'nid': nid,
        'advanceDeposit': advanceDeposit,
        'moveInDate': moveInDate.toIso8601String(),
        'email': email,
        'occupation': occupation,
        'alternatePhone': alternatePhone,
        'photoUrl': photoUrl,
        'moveOutDate': moveOutDate?.toIso8601String(),
        'isActive': isActive,
        'familyMembers': familyMembers.map((m) => m.toDocument()).toList(),
        'documents': documents.map((d) => d.toJson()).toList(),
        'landlordNotes': landlordNotes,
      };
}
