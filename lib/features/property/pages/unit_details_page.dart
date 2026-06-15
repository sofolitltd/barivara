import '/features/landing/repositories/listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/shared/widgets/responsive_layout.dart';
import '/shared/providers/home_providers.dart';

// Tab widgets
import '../widgets/unit_details/info_tab.dart';
import '../widgets/unit_details/renters_tab.dart';
import '../widgets/unit_details/billing_tab.dart';
import '../widgets/unit_details/market_tab.dart';

class UnitDetailsPage extends ConsumerStatefulWidget {
  final String propertyId;
  final String unitId;

  final String? initialTab;

  const UnitDetailsPage({
    super.key,
    required this.propertyId,
    required this.unitId,
    this.initialTab,
  });

  @override
  ConsumerState<UnitDetailsPage> createState() => _UnitDetailsPageState();
}

class _UnitDetailsPageState extends ConsumerState<UnitDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _primaryColor = Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    const tabNames = ['info', 'renter', 'billing', 'post'];
    int initialIndex = tabNames.indexOf(widget.initialTab ?? 'info');
    if (initialIndex < 0) initialIndex = 0;
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: initialIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final tabName = tabNames[_tabController.index];
        if (widget.initialTab != tabName) {
          context.go(
            '/landlord/properties/${widget.propertyId}/units/${widget.unitId}?tab=$tabName',
          );
        }
      }
    });
  }

  @override
  void didUpdateWidget(UnitDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      const tabNames = ['info', 'renter', 'billing', 'post'];
      final newIndex = tabNames.indexOf(widget.initialTab ?? 'info').clamp(0, 3);
      if (_tabController.index != newIndex) {
        _tabController.animateTo(newIndex);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final propertyAsync = ref.watch(propertyFutureProvider(widget.propertyId));
    final unitsAsync = ref.watch(unitsStreamProvider(widget.propertyId));
    final rentersAsync = ref.watch(
      rentersStreamProvider((widget.propertyId, widget.unitId)),
    );
    final invoicesAsync = ref.watch(
      invoicesStreamProvider((widget.propertyId, widget.unitId)),
    );
    final listingAsync = ref.watch(unitListingStreamProvider(widget.unitId));

    return SelectionArea(
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: MaxWidthContainer(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'Unit Management',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    unitsAsync.whenData((units) {
                      final unit = units.firstWhere(
                        (f) => f.id == widget.unitId,
                      );
                      context.go(
                        '/landlord/properties/${widget.propertyId}/units/${unit.id}/edit-unit',
                      );
                    });
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        body: MaxWidthContainer(
          child: propertyAsync.when(
            data: (property) => unitsAsync.when(
              data: (units) {
                final unit = units.firstWhere(
                  (f) => f.id == widget.unitId,
                  orElse: () => throw Exception('Unit not found'),
                );

                return NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24,16,24,0),
                        sliver: SliverPersistentHeader(
                          pinned: true,
                          delegate: _TabBarDelegate(
                            isDark: isDark,
                            tabController: _tabController,
                            primaryColor: _primaryColor,
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      InfoTab(
                        unit: unit,
                        property: property,
                        isDark: isDark,
                      ),
                      RentersTab(
                        rentersAsync: rentersAsync,
                        isDark: isDark,
                        propertyId: widget.propertyId,
                        unitId: widget.unitId,
                      ),
                      BillingTab(
                        invoicesAsync: invoicesAsync,
                        isDark: isDark,
                        propertyId: widget.propertyId,
                        unitId: widget.unitId,
                        propertyName: property.name,
                        unitName: unit.unitNumber,
                      ),
                      MarketTab(
                        listingAsync: listingAsync,
                        unit: unit,
                        isDark: isDark,
                        propertyId: widget.propertyId,
                        unitId: widget.unitId,
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }
}

// ── Tab bar pinned delegate ────────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final bool isDark;
  final TabController tabController;
  final Color primaryColor;

  const _TabBarDelegate({
    required this.isDark,
    required this.tabController,
    required this.primaryColor,
  });

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      child: TabBar(
        controller: tabController,
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Info'),
          Tab(text: 'Renter'),
          Tab(text: 'Billing'),
          Tab(text: 'Post'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.isDark != isDark || old.tabController != tabController;
}
