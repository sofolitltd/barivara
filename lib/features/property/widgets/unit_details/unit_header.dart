import 'package:flutter/material.dart';
import '../unit_stat_box.dart';
import '../../models/property.dart';
import '../../models/unit.dart';

class UnitHeader extends StatelessWidget {
  final Unit unit;
  final Property property;
  final bool isDark;

  const UnitHeader({
    super.key,
    required this.unit,
    required this.property,
    required this.isDark,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'occupied':
        return Colors.green;
      case 'vacant':
        return Colors.orange;
      case 'maintenance':
        return Colors.red;
      case 'reserved':
        return Colors.blue;
      case 'owner':
        return const Color(0xFF6366F1);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6366F1);
    final displayImage =
        unit.imageUrl ??
        property.imageUrl ??
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&q=80&w=1000';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                child: Image.network(
                  displayImage,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        unit.isOccupied
                            ? Icons.verified_user_rounded
                            : Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        unit.status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          unit.unitNumber,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              property.name,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: UnitStatBox(
                        icon: Icons.payments_outlined,
                        label: 'MONTHLY RENT',
                        value: '৳${unit.baseRent}',
                        color: primaryColor,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: UnitStatBox(
                        icon: Icons.info_outline,
                        label: 'FLAT STATUS',
                        value: unit.status,
                        color: _getStatusColor(unit.status),
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
