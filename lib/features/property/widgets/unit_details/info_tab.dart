import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/property.dart';
import '../../models/unit.dart';
import 'unit_stat_grid.dart';
import 'unit_summary_card.dart';

class InfoTab extends StatelessWidget {
  final Unit unit;
  final Property property;
  final bool isDark;

  static const _primaryColor = Color(0xFF6366F1);

  const InfoTab({
    super.key,
    required this.unit,
    required this.property,
    required this.isDark,
  });

  IconData _getMeterIcon(String type) {
    switch (type.toLowerCase().trim()) {
      case 'electricity':
        return Icons.bolt_outlined;
      case 'gas':
        return Icons.local_fire_department_outlined;
      case 'water':
        return Icons.water_drop_outlined;
      case 'internet':
        return Icons.wifi;
      case 'security':
        return Icons.security;
      case 'parking':
        return Icons.local_parking;
      case 'service':
        return Icons.cleaning_services;
      default:
        return Icons.qr_code_scanner;
    }
  }

  Widget _buildMetersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey.withValues(alpha: 0.12),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Utility Meters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          ...unit.meters.entries.map((entry) {
            final color = _primaryColor.withValues(alpha: 0.1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getMeterIcon(entry.key),
                      color: _primaryColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String title,
    required List<dynamic> entries,
    required String Function(dynamic) getAmount,
    required DateTime Function(dynamic) getDate,
    required String? Function(dynamic) getReason,
  }) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey.withValues(alpha: 0.12),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          ...entries.asMap().entries.map((entry) {
            final e = entry.value;
            final isFirst = entry.key == 0;
            return Padding(
              padding: EdgeInsets.only(bottom: isFirst ? 0 : 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isFirst ? Icons.circle : Icons.circle_outlined,
                      color: _primaryColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getAmount(e),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (getReason(e) != null)
                          Text(
                            getReason(e)!,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('MMM d, yyyy').format(getDate(e)),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalUtilities = unit.defaultUtilities.values.fold(
      0,
      (sum, val) => sum + val,
    );

    final stats = [
      UnitStatData(
        Icons.square_foot_rounded,
        'SIZE',
        unit.unitSize ?? 'N/A',
        _primaryColor,
      ),
      UnitStatData(
        Icons.category_outlined,
        'TYPE',
        unit.unitType ?? 'N/A',
        Colors.orange,
      ),
      UnitStatData(
        Icons.layers_outlined,
        'LEVEL',
        '${unit.floorLevel ?? "N/A"}',
        const Color(0xFF3B82F6),
      ),
      UnitStatData(
        Icons.security_rounded,
        'DEPOSIT',
        '৳${unit.securityDeposit ?? 0}',
        const Color(0xFF10B981),
      ),
      UnitStatData(
        Icons.receipt_long_rounded,
        'UTILITY',
        '৳$totalUtilities',
        const Color(0xFF8B5CF6),
      ),
      UnitStatData(
        Icons.payments_rounded,
        'RENT',
        '৳${unit.baseRent}',
        _primaryColor,
      ),
    ];

    final isDesktop = MediaQuery.of(context).size.width > 700;
    final children = <Widget>[
      UnitSummaryCard(
        unit: unit,
        property: property,
        isDark: isDark,
        isDesktop: isDesktop,
      ),
      const SizedBox(height: 12),
      UnitStatGrid(stats: stats, isDark: isDark),
    ];

    final sortedRentHistory = List<RentConfig>.from(unit.rentHistory)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (sortedRentHistory.isNotEmpty) {
      children.addAll([
        const SizedBox(height: 20),
        _buildHistoryCard(
          title: 'Rent History',
          entries: sortedRentHistory,
          getAmount: (e) => '৳${(e as RentConfig).amount}',
          getDate: (e) => (e as RentConfig).startDate,
          getReason: (e) => (e as RentConfig).reason,
        ),
      ]);
    }

    final sortedDepositHistory = List<DepositConfig>.from(unit.depositHistory)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (sortedDepositHistory.isNotEmpty) {
      children.addAll([
        const SizedBox(height: 20),
        _buildHistoryCard(
          title: 'Deposit History',
          entries: sortedDepositHistory,
          getAmount: (e) => '৳${(e as DepositConfig).amount}',
          getDate: (e) => (e as DepositConfig).startDate,
          getReason: (e) => (e as DepositConfig).reason,
        ),
      ]);
    }

    if (unit.meters.isNotEmpty) {
      children.addAll([
        const SizedBox(height: 20),
        _buildMetersCard(),
      ]);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: children),
    );
  }
}
