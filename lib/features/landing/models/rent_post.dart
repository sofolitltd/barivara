import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'rent_post.freezed.dart';
part 'rent_post.g.dart';

@freezed
abstract class RentPost with _$RentPost {
  const factory RentPost({
    String? id,
    required String unitId,
    required String propertyId,
    required String landlordId,
    required String title,
    required String description,
    required String location,
    required int rentAmount,
    @Default([]) List<String> imageUrls,
    required DateTime createdAt,
    @Default(true) bool isActive,
    String? propertyType,
    int? beds,
    int? baths,
    String? areaSqft,
  }) = _RentPost;

  const RentPost._();

  factory RentPost.fromJson(Map<String, dynamic> json) =>
      _$RentPostFromJson(json);

  factory RentPost.fromDocument(Map<String, dynamic> docData, String docId) {
    final data = Map<String, dynamic>.from(docData);
    data['id'] = docId;
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    return RentPost.fromJson(data);
  }
}
