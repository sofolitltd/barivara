import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barivara/features/onboarding/models/landlord_request.dart';
import 'package:barivara/features/auth/models/app_user.dart';
import 'dart:async';

final adminRepositoryProvider = Provider(
  (ref) => AdminRepository(FirebaseFirestore.instance),
);

class AdminStats {
  final int totalLandlords;
  final int totalProperties;
  final int pendingVerifications;
  final int totalRevenue;

  AdminStats({
    required this.totalLandlords,
    required this.totalProperties,
    required this.pendingVerifications,
    required this.totalRevenue,
  });
}

class AdminRepository {
  final FirebaseFirestore _firestore;

  AdminRepository(this._firestore);

  Stream<List<LandlordRequest>> watchPendingRequests() {
    return _firestore
        .collection('landlord_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return [];
          }
          return snapshot.docs
              .map((doc) => LandlordRequest.fromDocument(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<AdminStats> watchAdminStats() {
    // Combine multiple snapshots to provide real-time stats
    final landlordsStream = _firestore
        .collection('users')
        .where('role', isEqualTo: 'landlord')
        .snapshots();
        
    final postsStream = _firestore
        .collection('rent_posts')
        .snapshots();
        
    final pendingRequestsStream = _firestore
        .collection('landlord_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots();

    return StreamZip([
      landlordsStream,
      postsStream,
      pendingRequestsStream,
    ]).map((List<QuerySnapshot> snapshots) {
      final landlordDocs = snapshots[0].docs;
      final postDocs = snapshots[1].docs;
      final pendingDocs = snapshots[2].docs;
      
      return AdminStats(
        totalLandlords: landlordDocs.length,
        totalProperties: postDocs.length, // Labelled as 'Active Posts' in UI
        pendingVerifications: pendingDocs.length,
        totalRevenue: 0,
      );
    });
  }

  Stream<List<AppUser>> watchAllLandlords() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'landlord')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppUser.fromDocument(doc.data(), doc.id))
            .toList());
  }

  Future<void> submitLandlordRequest(
    LandlordRequest request,
    String email,
  ) async {
    final docRef = _firestore.collection('landlord_requests').doc();
    final newRequest = request.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
    );
    await docRef.set(newRequest.toJson());

    // Update/Create user document with all required fields to avoid null errors
    await _firestore.collection('users').doc(request.userId).set({
      'uid': request.userId,
      'name': request.userName,
      'email': email,
      'phone': request.phone,
      'role': 'pending_landlord',
      'status': 'pending',
    }, SetOptions(merge: true));
  }

  Future<void> approveLandlordRequest(String requestId, String userId) async {
    await _firestore.collection('landlord_requests').doc(requestId).update({
      'status': 'approved',
    });
    await _firestore.collection('users').doc(userId).update({
      'role': 'landlord',
      'status': 'approved',
    });
  }

  Future<void> rejectLandlordRequest(String requestId, String userId) async {
    await _firestore.collection('landlord_requests').doc(requestId).update({
      'status': 'rejected',
    });
    await _firestore.collection('users').doc(userId).update({
      'role': 'rejected_landlord',
      'status': 'rejected',
    });
  }
}

// Utility class to zip streams since standard Stream doesn't have zip in core anymore
class StreamZip<T> extends Stream<List<T>> {
  final Iterable<Stream<T>> _streams;
  StreamZip(this._streams);

  @override
  StreamSubscription<List<T>> listen(void Function(List<T> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final subscriptions = <StreamSubscription<T>>[];
    final controllers = StreamController<List<T>>(
      onCancel: () {
        for (final s in subscriptions) {
          s.cancel();
        }
      },
      sync: true,
    );

    final values = List<T?>.filled(_streams.length, null);
    final hasValue = List<bool>.filled(_streams.length, false);
    final done = List<bool>.filled(_streams.length, false);

    void check() {
      if (hasValue.every((v) => v)) {
        controllers.add(List<T>.from(values));
        for (var i = 0; i < hasValue.length; i++) {
          hasValue[i] = false;
        }
      }
    }

    var i = 0;
    for (final stream in _streams) {
      final index = i++;
      subscriptions.add(stream.listen(
        (data) {
          values[index] = data;
          hasValue[index] = true;
          check();
        },
        onError: controllers.addError,
        onDone: () {
          done[index] = true;
          if (done.every((d) => d)) {
            controllers.close();
          }
        },
        cancelOnError: cancelOnError,
      ));
    }

    return controllers.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
