import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider = Provider(
  (ref) => DashboardRepository(FirebaseFirestore.instance),
);

class MonthlyRevenue {
  final String month; // e.g. "Jan", "Feb"
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

  Stream<DashboardStats> watchLandlordStats(String ownerId) {
    return _firestore
        .collection('properties')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .asyncMap((propertySnap) async {
          final propertyDocs = propertySnap.docs;

          if (propertyDocs.isEmpty) {
            return DashboardStats(
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
          }

          double totalRev = 0;
          double totalDeposit = 0;
          int unpaidCount = 0;
          int vacantCount = 0;
          int occupiedCount = 0;
          int totalUnits = 0;
          final List<DashboardActivity> activities = [];

          // Monthly buckets (last 6 months)
          final Map<String, double> monthlyMap = {};
          final now = DateTime.now();
          const monthNames = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
          ];
          for (int i = 5; i >= 0; i--) {
            final d = DateTime(now.year, now.month - i, 1);
            final key = '${monthNames[d.month - 1]} ${d.year}';
            monthlyMap[key] = 0;
          }

          for (var propDoc in propertyDocs) {
            final propertyId = propDoc.id;

            final unitSnap = await _firestore
                .collection('units')
                .where('propertyId', isEqualTo: propertyId)
                .get();

            for (var unitDoc in unitSnap.docs) {
              final unitData = unitDoc.data();
              final unitId = unitDoc.id;
              totalUnits++;

              if (unitData['isOccupied'] == false) {
                vacantCount++;
              } else {
                occupiedCount++;
              }

              // Aggregate deposit from active renters
              final renterSnap = await _firestore
                  .collection('renters')
                  .where('propertyId', isEqualTo: propertyId)
                  .where('unitId', isEqualTo: unitId)
                  .where('status', isEqualTo: 'active')
                  .get();

              for (var renterDoc in renterSnap.docs) {
                final d = renterDoc.data();
                totalDeposit += (d['depositAmount'] as num? ?? 0).toDouble();

                final createdAt = _parseDate(d['createdAt']);
                if (createdAt != null) {
                  activities.add(DashboardActivity(
                    title: 'New Renter: ${d['name']}',
                    subtitle: 'Joined ${propDoc.data()['name']}',
                    icon: Icons.person_add_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    timestamp: createdAt,
                  ));
                }
              }

              // Aggregate invoices
              final invoiceSnap = await _firestore
                  .collection('invoices')
                  .where('propertyId', isEqualTo: propertyId)
                  .where('unitId', isEqualTo: unitId)
                  .get();

              for (var invDoc in invoiceSnap.docs) {
                final invData = invDoc.data();
                final amount = (invData['totalAmount'] as num? ?? 0).toDouble();

                if (invData['status'] == 'paid') {
                  totalRev += amount;

                  // Bucket into monthly
                  final dt = _parseDate(invData['paidAt']);
                  if (dt != null) {
                    final key = '${monthNames[dt.month - 1]} ${dt.year}';
                    if (monthlyMap.containsKey(key)) {
                      monthlyMap[key] = (monthlyMap[key] ?? 0) + amount;
                    }

                    activities.add(DashboardActivity(
                      title: 'Payment Received',
                      subtitle: '৳$amount received for ${invData['month']}',
                      icon: Icons.check_circle_rounded,
                      iconColor: const Color(0xFF10B981),
                      timestamp: dt,
                      onTap: () {
                        // Navigation logic would go here, e.g. using a global navigator or passing a route string
                      },
                    ));
                  }
                } else {
                  unpaidCount++;

                  final createdAt = _parseDate(invData['createdAt']);
                  if (createdAt != null) {
                    activities.add(DashboardActivity(
                      title: 'Invoice Generated',
                      subtitle: 'Pending ৳$amount for ${invData['month']}',
                      icon: Icons.receipt_long_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      timestamp: createdAt,
                    ));
                  }
                }
              }
            }
          }

          final monthlyList = monthlyMap.entries
              .map((e) => MonthlyRevenue(month: e.key, amount: e.value))
              .toList();

          // Sort activities by timestamp descending and take latest 10
          activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          final latestActivities = activities.take(10).toList();

          return DashboardStats(
            totalRevenue: totalRev,
            totalDeposit: totalDeposit,
            unpaidInvoicesCount: unpaidCount,
            vacantUnitsCount: vacantCount,
            occupiedUnitsCount: occupiedCount,
            totalUnitsCount: totalUnits,
            totalPropertiesCount: propertyDocs.length,
            monthlyRevenue: monthlyList,
            recentActivities: latestActivities,
          );
        });
  }
}
