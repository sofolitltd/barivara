import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barivara/features/property/models/property.dart';
import 'package:barivara/features/property/models/unit.dart';
import 'package:barivara/shared/services/cloudinary_service.dart';

final propertyRepositoryProvider = Provider(
  (ref) => PropertyRepository(FirebaseFirestore.instance),
);

class PropertyRepository {
  final FirebaseFirestore _firestore;

  PropertyRepository(this._firestore);

  Stream<List<Property>> watchProperties(String ownerId) {
    return _firestore
        .collection('properties')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map<List<Property>>(
          (snapshot) => snapshot.docs
              .map((doc) => Property.fromDocument(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<Property> getProperty(String propertyId) async {
    final doc = await _firestore.collection('properties').doc(propertyId).get();
    if (!doc.exists) throw Exception('Property not found');
    return Property.fromDocument(doc.data()!, doc.id);
  }

  Future<void> addProperty(Property property) async {
    final docRef = _firestore.collection('properties').doc();
    final newProperty = property.copyWith(id: docRef.id);
    await docRef.set(newProperty.toJson());
  }

  Future<void> updateProperty(Property property) async {
    await _firestore
        .collection('properties')
        .doc(property.id)
        .update(property.toJson());
  }

  Future<void> deleteProperty(String propertyId) async {
    // 1. Fetch property to check for an image and delete it from Cloudinary
    final property = await getProperty(propertyId);
    if (property.imageUrl != null &&
        property.imageUrl!.contains('cloudinary.com')) {
      await CloudinaryService.deleteImage(property.imageUrl!);
    }

    final batch = _firestore.batch();

    // 2. Delete all units and their images
    final unitsSnapshot = await _firestore
        .collection('units')
        .where('propertyId', isEqualTo: propertyId)
        .get();
    for (var doc in unitsSnapshot.docs) {
      final unit = Unit.fromDocument(doc.data(), doc.id);
      if (unit.imageUrl != null && unit.imageUrl!.contains('cloudinary.com')) {
        await CloudinaryService.deleteImage(unit.imageUrl!);
      }
      batch.delete(doc.reference);
    }

    // 3. Delete all renters and their images
    final rentersSnapshot = await _firestore
        .collection('renters')
        .where('propertyId', isEqualTo: propertyId)
        .get();
    for (var doc in rentersSnapshot.docs) {
      final data = doc.data();
      if (data['photoUrl'] != null &&
          data['photoUrl'].toString().contains('cloudinary.com')) {
        await CloudinaryService.deleteImage(data['photoUrl'].toString());
      }
      if (data['emergencyPhotoUrl'] != null &&
          data['emergencyPhotoUrl'].toString().contains('cloudinary.com')) {
        await CloudinaryService.deleteImage(
          data['emergencyPhotoUrl'].toString(),
        );
      }
      batch.delete(doc.reference);
    }

    // 4. Delete all market listings (rent_posts) and their images
    final rentPostsSnapshot = await _firestore
        .collection('rent_posts')
        .where('propertyId', isEqualTo: propertyId)
        .get();
    for (var doc in rentPostsSnapshot.docs) {
      final data = doc.data();
      final imageUrls = data['imageUrls'] as List<dynamic>? ?? [];
      for (var url in imageUrls) {
        if (url.toString().contains('cloudinary.com')) {
          await CloudinaryService.deleteImage(url.toString());
        }
      }
      batch.delete(doc.reference);
    }

    // 5. Delete all invoices
    final invoicesSnapshot = await _firestore
        .collection('invoices')
        .where('propertyId', isEqualTo: propertyId)
        .get();
    for (var doc in invoicesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // 6. Delete the property itself
    batch.delete(_firestore.collection('properties').doc(propertyId));

    // Commit all deletions
    await batch.commit();
  }

  // --- FLAT ARCH FLATS ---
  Stream<List<Unit>> watchUnits(String propertyId) {
    return _firestore
        .collection('units')
        .where('propertyId', isEqualTo: propertyId)
        .snapshots()
        .map<List<Unit>>(
          (snapshot) => snapshot.docs
              .map((doc) => Unit.fromDocument(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addUnit(Unit unit) async {
    final docRef = _firestore.collection('units').doc();
    final newUnit = unit.copyWith(id: docRef.id);
    final data = newUnit.toJson();
    data['rentHistory'] =
        newUnit.rentHistory.map((r) => r.toJson()).toList();
    data['depositHistory'] =
        newUnit.depositHistory.map((d) => d.toJson()).toList();
    await docRef.set(data);
  }

  Future<void> updateUnit(Unit unit) async {
    final data = unit.toJson();
    data['rentHistory'] =
        unit.rentHistory.map((r) => r.toJson()).toList();
    data['depositHistory'] =
        unit.depositHistory.map((d) => d.toJson()).toList();
    await _firestore.collection('units').doc(unit.id).update(data);
  }

  Future<void> deleteUnit(String propertyId, String unitId) async {
    await _firestore.collection('units').doc(unitId).delete();
  }

  Future<void> updateUnitOccupancy(
    String propertyId,
    String unitId, {
    required bool isOccupied,
  }) async {
    await _firestore.collection('units').doc(unitId).update({
      'isOccupied': isOccupied,
      'status': isOccupied ? 'occupied' : 'vacant',
    });
  }
}
