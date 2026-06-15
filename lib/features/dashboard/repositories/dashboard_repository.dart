import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final dashboardRepositoryProvider = Provider(
  (ref) => DashboardRepository(FirebaseFirestore.instance),
);

class MonthlyRevenue {
  final String month;
  final double amount;
  MonthlyRevenue({required this.month, required this.amount});
}

class DashboardActivity {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final DateTime timestamp;
  final VoidCallback? onTap;

  DashboardActivity({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.timestamp,
    this.onTap,
  });
}

class DashboardStats {
  final double totalRevenue;
  final double totalDeposit;
  final int unpaidInvoicesCount;
  final int vacantUnitsCount;
  final int occupiedUnitsCount;
  final int totalUnitsCount;
  final int totalPropertiesCount;
  final List<MonthlyRevenue> monthlyRevenue;
  final List<DashboardActivity> recentActivities;

  DashboardStats({
    required this.totalRevenue,
    required this.totalDeposit,
    required this.unpaidInvoicesCount,
    required this.vacantUnitsCount,
    required this.occupiedUnitsCount,
    required this.totalUnitsCount,
    required this.totalPropertiesCount,
    required this.monthlyRevenue,
    required this.recentActivities,
  });

  double get occupancyRate =>
      totalUnitsCount == 0 ? 0 : (occupiedUnitsCount / totalUnitsCount) * 100;
}

class DashboardRepository {
  final FirebaseFirestore _firestore;

  DashboardRepository(this._firestore);

  DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  DashboardStats _emptyStats() => DashboardStats(
        totalRevenue: 0,
        totalDeposit: 0,
        unpaidInvoicesCount: 0,
        vacantUnitsCount: 0,
        occupiedUnitsCount: 0,
        totalUnitsCount: 0,
        totalPropertiesCount: 0,
        monthlyRevenue: [],
        recentActivities: [],
      );

  DashboardStats _computeStats(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> propDocs,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> unitDocs,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> renterDocs,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> invoiceDocs,
  ) {
    final propIds = propDocs.map((d) => d.id).toSet();
    final propNameMap = {for (final d in propDocs) d.id: d.data()['name'] as String? ?? ''};

    double totalRev = 0;
    double totalDeposit = 0;
    int unpaidCount = 0;
    int vacantCount = 0;
    int occupiedCount = 0;
    final List<DashboardActivity> activities = [];

    final Map<String, double> monthlyMap = {};
    final now = DateTime.now();
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    for (int i = 5; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      monthlyMap['${monthNames[d.month - 1]} ${d.year}'] = 0;
    }

    // Group unit IDs by property for filtering renters/invoices
    final unitIdsByProp = <String, List<String>>{};
    final unitNameMap = <String, String>{};
    for (final propId in propIds) {
      unitIdsByProp[propId] = [];
    }

    for (final unitDoc in unitDocs) {
      final propId = unitDoc.data()['propertyId'] as String?;
      if (propId == null || !propIds.contains(propId)) continue;
      unitIdsByProp[propId]!.add(unitDoc.id);
      unitNameMap[unitDoc.id] = unitDoc.data()['unitNumber'] as String? ?? unitDoc.id;

      if (unitDoc.data()['isOccupied'] == false) {
        vacantCount++;
      } else {
        occupiedCount++;
      }
    }

    // Build a map of unitId → active tenant name
    final unitTenantMap = <String, String>{};
    for (final renterDoc in renterDocs) {
      final d = renterDoc.data();
      final propId = d['propertyId'] as String?;
      final unitId = d['unitId'] as String?;
      if (propId == null || unitId == null || !propIds.contains(propId)) continue;

      if (d['status'] == 'active') {
        unitTenantMap[unitId] = d['name'] as String? ?? '';
        totalDeposit += (d['depositAmount'] as num? ?? 0).toDouble();
      }

      final createdAt = _parseDate(d['createdAt']);
      if (createdAt != null) {
        final unitLabel = unitNameMap[unitId] ?? unitId;
        activities.add(DashboardActivity(
          title: 'New Renter: ${d['name']}',
          subtitle: 'Joined ${propNameMap[propId] ?? ''} · Unit $unitLabel',
          icon: Icons.person_add_rounded,
          iconColor: const Color(0xFF8B5CF6),
          timestamp: createdAt,
        ));
      }
    }

    final processedUnitIds = <String>{};
    for (final invDoc in invoiceDocs) {
      final invData = invDoc.data();
      final propId = invData['propertyId'] as String?;
      final unitId = invData['unitId'] as String?;
      if (propId == null || unitId == null || !propIds.contains(propId)) continue;

      final amount = (invData['totalAmount'] as num? ?? 0).toDouble();
      final unitLabel = unitNameMap[unitId] ?? unitId;
      final tenantName = unitTenantMap[unitId];

      if (invData['status'] == 'paid') {
        totalRev += amount;

        final dt = _parseDate(invData['paidAt']);
        if (dt != null) {
          final key = '${monthNames[dt.month - 1]} ${dt.year}';
          if (monthlyMap.containsKey(key)) {
            monthlyMap[key] = (monthlyMap[key] ?? 0) + amount;
          }
        }

        if (!processedUnitIds.contains(unitId)) {
          processedUnitIds.add(unitId);
          activities.add(DashboardActivity(
            title: 'Payment Received',
            subtitle: tenantName != null
                ? '৳$amount · Unit $unitLabel ($tenantName)'
                : '৳$amount · Unit $unitLabel',
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF10B981),
            timestamp: dt ?? now,
          ));
        }
      } else {
        unpaidCount++;

        final createdAt = _parseDate(invData['createdAt']);
        if (createdAt != null) {
          activities.add(DashboardActivity(
            title: 'Invoice Generated',
            subtitle: tenantName != null
                ? 'Pending ৳$amount · Unit $unitLabel ($tenantName)'
                : 'Pending ৳$amount · Unit $unitLabel',
            icon: Icons.receipt_long_rounded,
            iconColor: const Color(0xFFF59E0B),
            timestamp: createdAt,
          ));
        }
      }
    }

    int totalUnits = 0;
    for (final propId in propIds) {
      totalUnits += unitIdsByProp[propId]?.length ?? 0;
    }

    final monthlyList = monthlyMap.entries
        .map((e) => MonthlyRevenue(month: e.key, amount: e.value))
        .toList();

    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final latestActivities = activities.take(10).toList();

    return DashboardStats(
      totalRevenue: totalRev,
      totalDeposit: totalDeposit,
      unpaidInvoicesCount: unpaidCount,
      vacantUnitsCount: vacantCount,
      occupiedUnitsCount: occupiedCount,
      totalUnitsCount: totalUnits,
      totalPropertiesCount: propDocs.length,
      monthlyRevenue: monthlyList,
      recentActivities: latestActivities,
    );
  }

  Stream<DashboardStats> watchLandlordStats(String ownerId) {
    final propStream = _firestore
        .collection('properties')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((s) => s.docs);

    return propStream.switchMap((propDocs) {
      final propIds = propDocs.map((d) => d.id).toList();
      if (propIds.isEmpty) return Stream.value(_emptyStats());

      final q = propIds.length <= 10
          ? _firestore.collection('units').where('propertyId', whereIn: propIds)
          : _firestore.collection('units').where('propertyId', whereIn: propIds.sublist(0, 10));

      final unitsStream = q.snapshots();
      final rentersStream = _firestore
          .collection('renters')
          .where('propertyId', whereIn: propIds.length <= 10 ? propIds : propIds.sublist(0, 10))
          .snapshots();
      final invoicesStream = _firestore
          .collection('invoices')
          .where('propertyId', whereIn: propIds.length <= 10 ? propIds : propIds.sublist(0, 10))
          .snapshots();

      return CombineLatestStream.combine3(
        unitsStream,
        rentersStream,
        invoicesStream,
        (unitSnap, renterSnap, invoiceSnap) => _computeStats(
          propDocs,
          unitSnap.docs,
          renterSnap.docs,
          invoiceSnap.docs,
        ),
      );
    });
  }
}
