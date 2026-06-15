import 'package:flutter/material.dart';
import 'package:barivara/features/property/models/property.dart';
import 'package:barivara/features/property/models/unit.dart';

class UnitSummaryCard extends StatelessWidget {
  final Unit unit;
  final Property property;
  final bool isDark;
  final bool isDesktop;

  static const _primaryColor = Color(0xFF6366F1);

  const UnitSummaryCard({
    super.key,
    required this.unit,
    required this.property,
    required this.isDark,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = unit.isOccupied;
    final isOwner = unit.status == 'owner';
    final statusColor = isOwner
        ? const Color(0xFF6366F1)
        : isOccupied
            ? const Color(0xFF10B981)
            : Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: 16,
      ),
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
      child: Row(
        children: [
          // Image / placeholder
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: unit.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(unit.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              gradient: unit.imageUrl == null
                  ? LinearGradient(
                      colors: [
                        _primaryColor.withValues(alpha: 0.15),
                        _primaryColor.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: unit.imageUrl == null
                ? const Icon(
                    Icons.apartment_rounded,
                    color: _primaryColor,
                    size: 26,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Name + property
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unit ${unit.unitNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  property.name,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  unit.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
