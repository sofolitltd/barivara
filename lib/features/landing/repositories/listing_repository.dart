import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barivara/features/landing/models/rent_post.dart';

final listingRepositoryProvider = Provider(
  (ref) => ListingRepository(FirebaseFirestore.instance),
);

final unitListingStreamProvider = StreamProvider.family<RentPost?, String>((
  ref,
  unitId,
) {
  return ref.watch(listingRepositoryProvider).watchListingForUnit(unitId);
});

class ListingRepository {
  final FirebaseFirestore _firestore;

  ListingRepository(this._firestore);

  Stream<List<RentPost>> watchAllRentPosts() {
    return _firestore
        .collection('rent_posts')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return [];
          }
          return snapshot.docs
              .map((doc) => RentPost.fromDocument(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<RentPost?> watchListingForUnit(String unitId) {
    return _firestore
        .collection('rent_posts')
        .where('unitId', isEqualTo: unitId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return RentPost.fromDocument(
            snapshot.docs.first.data(),
            snapshot.docs.first.id,
          );
        });
  }

  Future<void> createRentPost(RentPost post) async {
    final docRef = _firestore.collection('rent_posts').doc();
    final newPost = post.copyWith(id: docRef.id, createdAt: DateTime.now());
    await docRef.set(newPost.toJson());
  }

  Future<void> updateRentPost(RentPost post) async {
    await _firestore
        .collection('rent_posts')
        .doc(post.id!)
        .update(post.toJson());
  }

  Future<void> deleteRentPost(String postId) async {
    await _firestore.collection('rent_posts').doc(postId).delete();
  }

  Future<RentPost?> getRentPost(String postId) async {
    final doc = await _firestore.collection('rent_posts').doc(postId).get();
    if (!doc.exists) return null;
    return RentPost.fromDocument(doc.data()!, doc.id);
  }
}
