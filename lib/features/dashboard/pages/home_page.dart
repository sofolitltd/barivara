import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barivara/features/dashboard/widgets/activity_item.dart';
import 'package:barivara/shared/widgets/glass_container.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';
import 'package:barivara/features/auth/providers/auth_providers.dart';
import 'package:barivara/shared/providers/home_providers.dart';
import 'package:barivara/features/dashboard/repositories/dashboard_repository.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return _buildErrorState(context, 'User not found. Please log in again.');
          }
          if (user.role == 'pending_landlord') {
            return _buildPendingState(context, isDark, user.name);
          }
          if (user.role == 'rejected_landlord') {
            return _buildRejectedState(context, isDark, user.name);
          }

          return MaxWidthContainer(
            child: SafeArea(
              child: Consumer(
                builder: (context, ref, _) {
                  final statsAsync = ref.watch(dashboardStatsProvider(user.uid));
                  return statsAsync.when(
                    data: (stats) => _buildDashboard(
                      context, ref, isDark, isDesktop, user.name, user.uid, stats,
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => _buildErrorState(context, e.toString()),
                  );
                },
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildErrorState(context, e.toString()),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    bool isDesktop,
    String name,
    String ownerId,
    DashboardStats stats,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref, isDark, isDesktop, name, stats),
                const SizedBox(height: 32),
                _buildKpiGrid(context, isDark, isDesktop, stats, ownerId),
                const SizedBox(height: 32),
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildRevenueChart(context, isDark, stats),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _buildOccupancyChart(context, isDark, stats),
                      ),
                    ],
                  )
                else ...[
                  _buildRevenueChart(context, isDark, stats),
                  const SizedBox(height: 24),
                  _buildOccupancyChart(context, isDark, stats),
                ],
                const SizedBox(height: 32),
                _buildActivityList(context, isDark, isDesktop, stats),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── HEADER ──────────────────────────────────────────────────────────────

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    bool isDark,
    bool isDesktop,
    String name,
    DashboardStats stats,
  ) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontSize: isDesktop ? 32 : 24,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${stats.totalPropertiesCount} ${stats.totalPropertiesCount == 1 ? 'property' : 'properties'} · ${stats.totalUnitsCount} units',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ref.watch(currentUserProvider).when(
          data: (user) => Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage:
                  user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
              child: user?.photoUrl == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ),
          loading: () => const SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, _) => const SizedBox(),
        ),
      ],
    );
  }

  // ─── KPI GRID ────────────────────────────────────────────────────────────

  Widget _buildKpiGrid(
    BuildContext context,
    bool isDark,
    bool isDesktop,
    DashboardStats stats,
    String ownerId,
  ) {
    final kpis = [
      _KpiData(
        label: 'Total Revenue',
        value: '৳${_formatCurrency(stats.totalRevenue)}',
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xFF10B981),
        subtitle: 'Collected rent',
        onTap: () => context.go('/landlord/properties'),
      ),
      _KpiData(
        label: 'Total Deposit',
        value: '৳${_formatCurrency(stats.totalDeposit)}',
        icon: Icons.savings_rounded,
        color: const Color(0xFF6366F1),
        subtitle: 'Security deposits',
        onTap: () => context.go('/landlord/properties'),
      ),
      _KpiData(
        label: 'Occupancy Rate',
        value: '${stats.occupancyRate.toStringAsFixed(1)}%',
        icon: Icons.home_rounded,
        color: const Color(0xFF3B82F6),
        subtitle: '${stats.occupiedUnitsCount} of ${stats.totalUnitsCount} units',
        onTap: () => context.go('/landlord/properties'),
      ),
      _KpiData(
        label: 'Unpaid Invoices',
        value: '${stats.unpaidInvoicesCount}',
        icon: Icons.receipt_long_rounded,
        color: const Color(0xFFEF4444),
        subtitle: '${stats.vacantUnitsCount} vacant units',
        onTap: () => context.push('/landlord/unpaid-invoices', extra: ownerId),
      ),
    ];

    if (isDesktop) {
      return Row(
        children: kpis
            .map((k) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildKpiCard(isDark, k, fixedHeight: 120),
                  ),
                ))
            .toList(),
      );
    }

    // Tablet & mobile: LayoutBuilder-based Wrap so cards hug content
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;
        final spacing = 12.0;
        final cols = isTablet ? 4 : 2;
        final cardWidth =
            (constraints.maxWidth - spacing * (cols - 1)) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: kpis
              .map((k) => SizedBox(
                    width: cardWidth,
                    child: _buildKpiCard(isDark, k),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildKpiCard(bool isDark, _KpiData data, {double? fixedHeight}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassContainer(
          isDark: isDark,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(data.icon, color: data.color, size: 18),
              ),
              const SizedBox(height: 10),
              Text(
                data.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                data.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                data.subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── REVENUE CHART ────────────────────────────────────────────────────────

  Widget _buildRevenueChart(
    BuildContext context,
    bool isDark,
    DashboardStats stats, 
  ) {
    final data = stats.monthlyRevenue;
    final hasData = data.isNotEmpty && data.any((m) => m.amount > 0);

    return GlassContainer(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Revenue Trend',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Last 6 months',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: hasData
                ? LineChart(_buildLineChartData(isDark, data))
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bar_chart_rounded,
                            size: 40, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'No revenue data yet',
                          style: TextStyle(color: Colors.grey[500], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildLineChartData(bool isDark, List<MonthlyRevenue> data) {
    final spots = <FlSpot>[];
    double maxY = 0;

    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].amount));
      if (data[i].amount > maxY) maxY = data[i].amount;
    }
    if (maxY == 0) maxY = 1000;

    final gridColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);
    final labelColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 4,
        getDrawingHorizontalLine: (_) => FlLine(color: gridColor, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 52,
            interval: maxY / 4,
            getTitlesWidget: (v, _) => Text(
              _shortCurrency(v),
              style: TextStyle(fontSize: 10, color: labelColor),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            interval: 1,
            getTitlesWidget: (v, _) {
              final idx = v.toInt();
              if (idx < 0 || idx >= data.length) return const SizedBox();
              final parts = data[idx].month.split(' ');
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  parts.length == 2 ? '${parts[0]}\n${parts[1]}' : parts[0],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9, color: labelColor, height: 1.2),
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: 0,
      maxY: maxY * 1.2,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: const Color(0xFF10B981),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (_, _, _, i) => FlDotCirclePainter(
              radius: 4,
              color: const Color(0xFF10B981),
              strokeWidth: 2,
              strokeColor: Colors.white,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF10B981).withValues(alpha: 0.25),
                const Color(0xFF10B981).withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) =>
              isDark ? const Color(0xFF1E293B) : Colors.white,
          getTooltipItems: (spots) => spots
              .map((s) => LineTooltipItem(
                    '৳ ${_formatCurrency(s.y)}',
                    const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    children: const [],
                  ))
              .toList(),
        ),
      ),
    );
  }

  // ─── OCCUPANCY CHART ─────────────────────────────────────────────────────

  Widget _buildOccupancyChart(
    BuildContext context,
    bool isDark,
    DashboardStats stats,
  ) {
    final occupied = stats.occupiedUnitsCount.toDouble();
    final vacant = stats.vacantUnitsCount.toDouble();
    final total = stats.totalUnitsCount;

    return GlassContainer(
      isDark: isDark,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Occupancy Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),
          if (total == 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.home_outlined, size: 40, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text('No units yet',
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 52,
                  sections: [
                    PieChartSectionData(
                      value: occupied,
                      color: const Color(0xFF6366F1),
                      title: occupied > 0
                          ? '${((occupied / total) * 100).toStringAsFixed(0)}%'
                          : '',
                      radius: 36,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: vacant,
                      color: const Color(0xFFF59E0B),
                      title: vacant > 0
                          ? '${((vacant / total) * 100).toStringAsFixed(0)}%'
                          : '',
                      radius: 36,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildLegendItem(
                  'Occupied',
                  '${stats.occupiedUnitsCount}',
                  const Color(0xFF6366F1),
                  isDark,
                ),
                const SizedBox(width: 24),
                _buildLegendItem(
                  'Vacant',
                  '${stats.vacantUnitsCount}',
                  const Color(0xFFF59E0B),
                  isDark,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─── ACTIVITY LIST ────────────────────────────────────────────────────────
 
  Widget _buildActivityList(
    BuildContext context,
    bool isDark,
    bool isDesktop,
    DashboardStats stats,
  ) {
    final activities = stats.recentActivities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            if (activities.isNotEmpty)
              TextButton(
                onPressed: () {}, // Link to a full logs page if needed
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (activities.isEmpty)
          GlassContainer(
            isDark: isDark,
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.history_rounded,
                      size: 40, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'No recent activity yet',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ActivityItem(
                icon: activity.icon,
                iconColor: activity.iconColor,
                title: activity.title,
                subtitle:
                    '${activity.subtitle} • ${_timeAgo(activity.timestamp)}',
                isDark: isDark,
                onTap: activity.onTap,
              );
            },
          ),
      ],
    );
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  Widget _buildLegendItem(
      String label, String value, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            Text(
              '$value units',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  // ─── PENDING / REJECTED / ERROR STATES ──────────────────────────────────

  Widget _buildPendingState(BuildContext context, bool isDark, String name) {
    return Center(
      child: MaxWidthContainer(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_empty_rounded,
                    size: 64, color: Color(0xFF6366F1)),
              ),
              const SizedBox(height: 32),
              Text(
                'Verification in Progress',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Hi $name, your landlord application is being reviewed. This usually takes 24-48 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRejectedState(BuildContext context, bool isDark, String name) {
    return Center(
      child: MaxWidthContainer(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error_outline_rounded,
                    size: 64, color: Colors.red),
              ),
              const SizedBox(height: 32),
              const Text(
                'Application Rejected',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w800, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We couldn\'t verify your profile. Please check your documents and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(child: Text('Error: $error'));
  }

  // ─── HELPERS ─────────────────────────────────────────────────────────────

  String _formatCurrency(double value) {
    if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _shortCurrency(double value) {
    if (value >= 100000) return '${(value / 100000).toStringAsFixed(0)}L';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(0);
  }
}

class _KpiData {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _KpiData({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });
}
