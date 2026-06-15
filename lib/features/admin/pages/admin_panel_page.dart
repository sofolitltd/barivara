import 'package:barivara/features/onboarding/models/landlord_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barivara/shared/providers/home_providers.dart';
import 'package:barivara/features/admin/repositories/admin_repository.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';
import 'package:barivara/shared/widgets/glass_container.dart';
import 'package:intl/intl.dart';

class AdminPanelPage extends ConsumerStatefulWidget {
  const AdminPanelPage({super.key});

  @override
  ConsumerState<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends ConsumerState<AdminPanelPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final requestsAsync = ref.watch(pendingLandlordRequestsStreamProvider);
    final statsAsync = ref.watch(adminStatsProvider);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return SelectionArea(
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: MaxWidthContainer(
            child: AppBar(
              title: const Text('Admin Command Center', style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: false,
              actions: [
                IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF6366F1),
                  child: Text('A', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        body: MaxWidthContainer(
          child: Column(
            children: [
              // --- STATS OVERVIEW ---
              Padding(
                padding: const EdgeInsets.all(20),
                child: statsAsync.when(
                  data: (stats) => _buildStatsOverview(isDark, isDesktop, stats),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),

              // --- TABS ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF6366F1),
                  labelColor: const Color(0xFF6366F1),
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: const [
                    Tab(text: 'Verifications'),
                    Tab(text: 'Landlords'),
                    Tab(text: 'Reports'),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // VERIFICATIONS TAB
                    _buildVerificationsTab(requestsAsync, isDark, isDesktop),
                    // LANDLORDS TAB
                    _buildLandlordsTab(isDark, isDesktop),
                    const Center(child: Text('System Reports Coming Soon')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview(bool isDark, bool isDesktop, AdminStats stats) {
    if (isDesktop) {
      return Row(
        children: [
          _statCard('Total Landlords', stats.totalLandlords.toString(), Icons.people_outline, Colors.blue, isDark),
          const SizedBox(width: 16),
          _statCard('Active Posts', stats.totalProperties.toString(), Icons.home_outlined, Colors.green, isDark),
          const SizedBox(width: 16),
          _statCard('Pending Verification', stats.pendingVerifications.toString(), Icons.verified_user_outlined, Colors.orange, isDark),
          const SizedBox(width: 16),
          _statCard('Monthly Revenue', '৳ ${stats.totalRevenue}', Icons.payments_outlined, Colors.purple, isDark),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              _statCard('Total Landlords', stats.totalLandlords.toString(), Icons.people_outline, Colors.blue, isDark),
              const SizedBox(width: 16),
              _statCard('Active Posts', stats.totalProperties.toString(), Icons.home_outlined, Colors.green, isDark),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard('Pending Verification', stats.pendingVerifications.toString(), Icons.verified_user_outlined, Colors.orange, isDark),
              const SizedBox(width: 16),
              _statCard('Monthly Revenue', '৳ ${stats.totalRevenue}', Icons.payments_outlined, Colors.purple, isDark),
            ],
          ),
        ],
      );
    }
  }

  Widget _statCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: GlassContainer(
        isDark: isDark,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 16),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationsTab(AsyncValue requestsAsync, bool isDark, bool isDesktop) {
    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text('All clear!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('No pending verification requests.'),
              ],
            ),
          );
        }

        final crossAxisCount = isDesktop ? 3 : (ResponsiveLayout.isTablet(context) ? 2 : 1);

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 340,
          ),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return _VerificationCard(request: request, isDark: isDark);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildLandlordsTab(bool isDark, bool isDesktop) {
    final landlordsAsync = ref.watch(allLandlordsProvider);

    return landlordsAsync.when(
      data: (landlords) {
        if (landlords.isEmpty) {
          return Center(child: Text('No landlords found', style: TextStyle(color: Colors.grey[500])));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: landlords.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final landlord = landlords[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    child: Text(landlord.name[0], style: const TextStyle(color: Color(0xFF6366F1))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(landlord.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(landlord.email, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(landlord.phone, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Verified', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _VerificationCard extends ConsumerWidget {
  final LandlordRequest request;
  final bool isDark;

  const _VerificationCard({required this.request, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(adminRepositoryProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  child: Text(request.userName[0], style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        'Requested ${DateFormat.yMMMd().format(request.createdAt)}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                  child: const Text('New', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow(Icons.phone_outlined, request.phone),
                const SizedBox(height: 8),
                _detailRow(Icons.badge_outlined, 'NID: ${request.nidNumber}'),
                const SizedBox(height: 16),
                if (request.ownerProofImageUrl.isEmpty)
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_photography_outlined, color: Colors.grey[400]),
                        const SizedBox(height: 4),
                        Text('No Proof Uploaded', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.network(
                          request.ownerProofImageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, _) => Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.3),
                            child: Center(
                              child: TextButton(
                                onPressed: () => _showProofDialog(context, request.ownerProofImageUrl),
                                child: const Text('View Proof', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => repository.rejectLandlordRequest(request.id!, request.userId),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => repository.approveLandlordRequest(request.id!, request.userId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  void _showProofDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              title: const Text('Proof of Ownership', style: TextStyle(color: Colors.white)),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
