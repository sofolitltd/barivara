import 'package:freezed_annotation/freezed_annotation.dart';

part 'property.freezed.dart';
part 'property.g.dart';

@freezed
abstract class Property with _$Property {
  const factory Property({
    required String id,
    required String ownerId,
    required String name,
    required String address,
    String? googleMapsUrl,
    String? propertyType,
    String? imageUrl,
    String? videoUrl,
  }) = _Property;

  const Property._();

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);

  factory Property.fromDocument(Map<String, dynamic> docData, String docId) {
    return Property.fromJson(docData).copyWith(id: docId);
  }
}
