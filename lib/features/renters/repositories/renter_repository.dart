import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:barivara/features/renters/models/renter.dart';
import 'package:barivara/features/billing/models/invoice.dart';

final renterRepositoryProvider = Provider(
  (ref) => RenterRepository(FirebaseFirestore.instance),
);

class RenterRepository {
  final FirebaseFirestore _firestore;

  RenterRepository(this._firestore);

  Future<bool> hasActiveRenter(String propertyId, String unitId) async {
    final snapshot = await _firestore
        .collection('renters')
        .where('propertyId', isEqualTo: propertyId)
        .where('unitId', isEqualTo: unitId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // --- FLAT RENTERS ---
  Stream<List<Renter>> watchActiveRenter(String propertyId, String unitId) {
    return _firestore
        .collection('renters')
        .where('propertyId', isEqualTo: propertyId)
        .where('unitId', isEqualTo: unitId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Renter.fromDocument(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Renter>> watchRenterHistory(String propertyId, String unitId) {
    return _firestore
        .collection('renters')
        .where('propertyId', isEqualTo: propertyId)
        .where('unitId', isEqualTo: unitId)
        .where('isActive', isEqualTo: false)
        // .orderBy('moveOutDate', descending: true)//todo
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Renter.fromDocument(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addRenter(
    String propertyId,
    String unitId,
    Renter renter,
  ) async {
    final docRef = _firestore.collection('renters').doc();
    final newRenter = renter.copyWith(
      id: docRef.id,
      propertyId: propertyId,
      unitId: unitId,
      isActive: true,
    );
    await docRef.set(newRenter.toDocument());

    // Also update the unit status in unit collection
    await _firestore.collection('units').doc(unitId).update({
      'isOccupied': true,
      'status': 'occupied',
    });
  }

  Future<void> updateRenter(
    String propertyId,
    String unitId,
    Renter renter,
  ) async {
    await _firestore
        .collection('renters')
        .doc(renter.id)
        .update(renter.toDocument());
  }

  Future<void> vacateRenter(
    String propertyId,
    String unitId,
    String renterId,
    DateTime moveOutDate,
  ) async {
    await _firestore.collection('renters').doc(renterId).update({
      'isActive': false,
      'moveOutDate': moveOutDate.toIso8601String(),
    });

    // Also update the unit status in unit collection
    await _firestore.collection('units').doc(unitId).update({
      'isOccupied': false,
      'status': 'vacant',
    });
  }

  Future<void> deleteRenter(
    String propertyId,
    String unitId,
    String renterId,
  ) async {
    final batch = _firestore.batch();

    // 1. Delete the renter document
    final renterDoc = _firestore.collection('renters').doc(renterId);
    final renterData = await renterDoc.get();
    final bool wasActive = renterData.data()?['isActive'] ?? false;
    batch.delete(renterDoc);

    // 2. Delete associated invoices
    final invoicesSnapshot = await _firestore
        .collection('invoices')
        .where('renterId', isEqualTo: renterId)
        .get();
    for (final doc in invoicesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // 3. If it was the active renter, mark unit as vacant
    if (wasActive) {
      batch.update(_firestore.collection('units').doc(unitId), {
        'isOccupied': false,
        'status': 'vacant',
      });
    }

    await batch.commit();
  }

  Future<void> restoreRenter(
    String propertyId,
    String unitId,
    String renterId,
  ) async {
    await _firestore.collection('renters').doc(renterId).update({
      'isActive': true,
      'moveOutDate': null,
    });

    // Also update the unit status in unit collection
    await _firestore.collection('units').doc(unitId).update({
      'isOccupied': true,
      'status': 'occupied',
    });
  }

  // --- FLAT INVOICES ---
  Stream<List<Invoice>> watchInvoices(String propertyId, String unitId) {
    return _firestore
        .collection('invoices')
        .where('propertyId', isEqualTo: propertyId)
        .where('unitId', isEqualTo: unitId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Invoice.fromDocument(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Invoice>> watchAllInvoices(String propertyId) {
    return _firestore
        .collection('invoices')
        .where('propertyId', isEqualTo: propertyId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Invoice.fromDocument(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Invoice>> watchUnpaidInvoicesForOwner(String ownerId) {
    return _firestore
        .collection('properties')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .switchMap((propSnapshot) {
      final propIds = propSnapshot.docs.map((d) => d.id).toList();
      if (propIds.isEmpty) return Stream.value([]);
      return _firestore
          .collection('invoices')
          .where('propertyId', whereIn: propIds.length <= 10 ? propIds : propIds.sublist(0, 10))
          .where('status', whereIn: ['unpaid', 'due'])
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Invoice.fromDocument(doc.data(), doc.id))
              .toList());
    });
  }

  Future<Invoice> addInvoice(
    String propertyId,
    String unitId,
    Invoice invoice,
  ) async {
    // Fetch active renter to store name + id on the invoice
    final renterSnapshot = await _firestore
        .collection('renters')
        .where('propertyId', isEqualTo: propertyId)
        .where('unitId', isEqualTo: unitId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    String? renterName;
    String? renterId;
    if (renterSnapshot.docs.isNotEmpty) {
      final doc = renterSnapshot.docs.first;
      renterName = doc.data()['name'] as String?;
      renterId = doc.id;
    } else {
      throw Exception('No active renter found for this unit. Please add a renter before creating a bill.');
    }

    // Atomically increment per-property counter for sequential invoice number
    final counterRef = _firestore.collection('counters').doc(propertyId);
    final invoiceNumber = await _firestore.runTransaction<String>((tx) async {
      final doc = await tx.get(counterRef);
      final current = (doc.data()?['invoiceCurrent'] as int? ?? 0) + 1;
      tx.set(counterRef, {'invoiceCurrent': current}, SetOptions(merge: true));
      return current.toString().padLeft(4, '0');
    });

    final docRef = _firestore.collection('invoices').doc();
    final newInvoice = invoice.copyWith(
      id: docRef.id,
      invoiceNumber: invoiceNumber,
      propertyId: propertyId,
      unitId: unitId,
      renterName: renterName,
      renterId: renterId,
      createdAt: DateTime.now(),
    );
    final data = newInvoice.toJson();
    data['payments'] = newInvoice.payments.map((p) => p.toJson()).toList();
    await docRef.set(data);
    return newInvoice;
  }

  Future<void> markInvoicePaid(
    String propertyId,
    String unitId,
    String invoiceId,
  ) async {
    final invoiceDoc = _firestore.collection('invoices').doc(invoiceId);
    final snapshot = await invoiceDoc.get();
    if (!snapshot.exists) return;
    final invoice = Invoice.fromDocument(snapshot.data()!, invoiceId);
    final payment = Payment(
      amount: invoice.remainingBalance,
      paidAt: DateTime.now(),
      note: 'Full payment',
    );
    final updatedPayments = [...invoice.payments, payment];
    await invoiceDoc.update({
      'status': 'paid',
      'paidAt': DateTime.now().toIso8601String(),
      'payments': updatedPayments.map((p) => p.toJson()).toList(),
    });
  }

  Future<void> updateInvoiceStatus(String invoiceId, String status) async {
    final updateData = <String, dynamic>{'status': status};
    if (status.toLowerCase() == 'paid') {
      updateData['paidAt'] = DateTime.now().toIso8601String();
    } else {
      updateData['paidAt'] = FieldValue.delete();
    }
    await _firestore.collection('invoices').doc(invoiceId).update(updateData);
  }

  Future<void> deleteInvoice(String invoiceId) async {
    await _firestore.collection('invoices').doc(invoiceId).delete();
  }

  Future<void> clearPayments(String invoiceId) async {
    await _firestore.collection('invoices').doc(invoiceId).update({
      'payments': [],
      'status': 'unpaid',
      'paidAt': FieldValue.delete(),
    });
  }

  Future<void> updateInvoice(Invoice invoice) async {
    final data = invoice.toJson();
    data['payments'] = invoice.payments.map((p) => p.toJson()).toList();
    await _firestore
        .collection('invoices')
        .doc(invoice.id)
        .update(data);
  }

  Future<void> recordPayment({
    required String invoiceId,
    required int amount,
    required DateTime paidAt,
    String? note,
    List<String> paidItems = const [],
  }) async {
    final invoiceDoc = _firestore.collection('invoices').doc(invoiceId);
    final snapshot = await invoiceDoc.get();
    if (!snapshot.exists) throw Exception('Invoice not found');

    final invoice = Invoice.fromDocument(snapshot.data()!, invoiceId);
    final newPayment = Payment(
      amount: amount,
      paidAt: paidAt,
      note: note,
      paidItems: paidItems,
    );
    final updatedPayments = [...invoice.payments, newPayment];
    final paidAmount =
        updatedPayments.fold<int>(0, (total, p) => total + p.amount);

    final isFullyPaid = paidAmount >= invoice.totalAmount;
    final updateData = <String, dynamic>{
      'payments': updatedPayments.map((p) => p.toJson()).toList(),
      'status': isFullyPaid ? 'paid' : 'unpaid',
    };
    if (isFullyPaid) {
      updateData['paidAt'] = paidAt.toIso8601String();
    } else {
      updateData['paidAt'] = FieldValue.delete();
    }
    await invoiceDoc.update(updateData);
  }

  Future<void> removePaidItem(String invoiceId, String itemName) async {
    final invoiceDoc = _firestore.collection('invoices').doc(invoiceId);
    final snapshot = await invoiceDoc.get();
    if (!snapshot.exists) throw Exception('Invoice not found');

    final invoice = Invoice.fromDocument(snapshot.data()!, invoiceId);
    final itemAmount = invoice.chargeAmount(itemName);
    final updatedPayments = <Payment>[];
    for (final payment in invoice.payments) {
      if (payment.paidItems.contains(itemName)) {
        final updatedItems = payment.paidItems
            .where((i) => i != itemName)
            .toList();
        if (updatedItems.isNotEmpty) {
          updatedPayments.add(payment.copyWith(
            paidItems: updatedItems,
            amount: payment.amount - itemAmount,
          ));
        }
      } else {
        updatedPayments.add(payment);
      }
    }

    final paidAmount = updatedPayments.fold<int>(0, (t, p) => t + p.amount);
    final isFullyPaid = paidAmount >= invoice.totalAmount;
    final updateData = <String, dynamic>{
      'payments': updatedPayments.map((p) => p.toJson()).toList(),
      'status': isFullyPaid ? 'paid' : 'unpaid',
    };
    if (!isFullyPaid) updateData['paidAt'] = FieldValue.delete();
    await invoiceDoc.update(updateData);
  }

  Future<Invoice> getInvoice(String invoiceId) async {
    final doc = await _firestore.collection('invoices').doc(invoiceId).get();
    if (!doc.exists) throw Exception('Invoice not found');
    return Invoice.fromDocument(doc.data()!, doc.id);
  }

  Stream<Invoice> watchInvoice(String invoiceId) {
    return _firestore
        .collection('invoices')
        .doc(invoiceId)
        .snapshots()
        .map((snapshot) => Invoice.fromDocument(snapshot.data()!, snapshot.id));
  }

  Future<Renter> getRenter(String renterId) async {
    final doc = await _firestore.collection('renters').doc(renterId).get();
    if (!doc.exists) throw Exception('Renter not found');
    return Renter.fromDocument(doc.data()!, doc.id);
  }
}
