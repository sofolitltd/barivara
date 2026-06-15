import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barivara/features/auth/models/app_user.dart';

final userRepositoryProvider = Provider((ref) => UserRepository(FirebaseFirestore.instance));

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromDocument(doc.data()!, doc.id);
  }

  Stream<AppUser?> watchUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromDocument(doc.data()!, doc.id);
    });
  }

  Future<String> getNextIncrementalUserId() async {
    final counterRef = _firestore.collection('counters').doc('users');
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        transaction.set(counterRef, {'current': 1});
        return 'user_1';
      }
      final current = snapshot.data()!['current'] as int;
      final next = current + 1;
      transaction.update(counterRef, {'current': next});
      return 'user_$next';
    });
  }
}
