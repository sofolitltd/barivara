import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String name,
    required String email,
    required String phone,
    @Default('renter') String role, // 'renter', 'landlord', 'admin'
    @Default('none') String status, // 'none', 'pending', 'approved', 'rejected'
    String? photoUrl,
  }) = _AppUser;

  const AppUser._();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  factory AppUser.fromDocument(Map<String, dynamic> docData, String docId) {
    // Sanitize data to prevent null pointer exceptions for required fields
    final sanitizedData = Map<String, dynamic>.from(docData);
    sanitizedData['uid'] = docId;
    sanitizedData['name'] ??= 'Unknown User';
    sanitizedData['email'] ??= '';
    sanitizedData['phone'] ??= '';
    sanitizedData['role'] ??= 'renter';
    sanitizedData['status'] ??= 'none';
    sanitizedData['photoUrl'] = docData['photoUrl'];

    return AppUser.fromJson(sanitizedData);
  }
}
