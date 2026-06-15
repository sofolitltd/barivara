import 'package:flutter/material.dart';

class UnitStatData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const UnitStatData(this.icon, this.label, this.value, this.color);
}

/// A single horizontal stat chip: [icon] | [LABEL / value]
class UnitStatChip extends StatelessWidget {
  final UnitStatData stat;
  final bool isDark;

  const UnitStatChip({super.key, required this.stat, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.grey.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: stat.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(stat.icon, color: stat.color, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[500],
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive grid of stat chips.
/// Mobile: 2 per row · Tablet: 3 per row · Desktop: all 6 in one row.
class UnitStatGrid extends StatelessWidget {
  final List<UnitStatData> stats;
  final bool isDark;

  const UnitStatGrid({super.key, required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isDesktop = w > 700;
        final isTablet = w > 500;
        final perRow = isDesktop ? 6 : (isTablet ? 3 : 2);
        const spacing = 10.0;
        final chipWidth = (w - spacing * (perRow - 1)) / perRow;

        final rows = <Widget>[];
        for (var i = 0; i < stats.length; i += perRow) {
          final rowStats = stats.sublist(
            i,
            (i + perRow).clamp(0, stats.length),
          );
          rows.add(
            Row(
              children: rowStats.asMap().entries.map((entry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: chipWidth,
                      child: UnitStatChip(stat: entry.value, isDark: isDark),
                    ),
                    if (entry.key < rowStats.length - 1)
                      const SizedBox(width: spacing),
                  ],
                );
              }).toList(),
            ),
          );
          if (i + perRow < stats.length) {
            rows.add(const SizedBox(height: spacing));
          }
        }

        return Column(children: rows);
      },
    );
  }
}
