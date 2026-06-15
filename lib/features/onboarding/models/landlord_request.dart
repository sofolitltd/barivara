import 'package:freezed_annotation/freezed_annotation.dart';

part 'landlord_request.freezed.dart';
part 'landlord_request.g.dart';

@freezed
abstract class LandlordRequest with _$LandlordRequest {
  const factory LandlordRequest({
    String? id,
    required String userId,
    required String userName,
    required String phone,
    required String nidNumber,
    required String ownerProofImageUrl,
    @Default('pending') String status, // 'pending', 'approved', 'rejected'
    required DateTime createdAt,
  }) = _LandlordRequest;

  factory LandlordRequest.fromJson(Map<String, dynamic> json) =>
      _$LandlordRequestFromJson(json);

  factory LandlordRequest.fromDocument(Map<String, dynamic> docData, String docId) {
    return LandlordRequest.fromJson(docData).copyWith(id: docId);
  }
}
