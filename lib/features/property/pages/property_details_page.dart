import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barivara/shared/providers/home_providers.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';
import 'package:barivara/features/property/repositories/property_repository.dart';
import '../models/unit.dart';
import '../widgets/unit_card.dart';

class HomeOverviewPage extends ConsumerWidget {
  final String propertyId;

  const HomeOverviewPage({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    final propertyAsync = ref.watch(propertyFutureProvider(propertyId));
    final unitsAsync = ref.watch(unitsStreamProvider(propertyId));

    return Scaffold(
      body: MaxWidthContainer(
        child: SafeArea(
          child: propertyAsync.when(
            data: (property) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    pinned: true,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    title: Text(
                      property.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => context.go(
                          '/landlord/properties/$propertyId/units/add-unit',
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            context.go(
                              '/landlord/properties/edit-property/${property.id}',
                            );
                          } else if (value == 'delete') {
                            _showDeleteHouseConfirmation(
                              context,
                              ref,
                              property.name,
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Edit House'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete House',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Manage Units',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(padding: EdgeInsets.only(bottom: 16)),

                  //
                  unitsAsync.when(
                    data: (units) {
                      if (units.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.bedroom_parent_outlined,
                                    size: 64,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'No units added yet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start by adding your first unit or apartment\nto this property.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton.icon(
                                  onPressed: () => context.go(
                                    '/landlord/properties/$propertyId/units/add-unit',
                                  ),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add First Unit'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final crossAxisCount = isDesktop
                          ? 2
                          : (ResponsiveLayout.isTablet(context) ? 2 : 1);

                      // Group units by floorLevel
                      final Map<int?, List<Unit>> grouped = {};
                      for (final unit in units) {
                        final key = unit.floorLevel;
                        grouped.putIfAbsent(key, () => []).add(unit);
                      }

                      // Sort: numbered levels first (ascending), then null
                      final sortedKeys = grouped.keys.toList()
                        ..sort((a, b) {
                          if (a == null && b == null) return 0;
                          if (a == null) return 1;
                          if (b == null) return -1;
                          return a.compareTo(b);
                        });

                      // Build a unit list of sliver items: header + grid rows
                      final List<Widget> slivers = [];
                      for (final level in sortedKeys) {
                        final levelUnits = grouped[level]!;
                        final label = level != null
                            ? 'Level $level'
                            : 'Other Units';

                        slivers.add(
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                            sliver: SliverToBoxAdapter(
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${levelUnits.length} unit${levelUnits.length == 1 ? '' : 's'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                        slivers.add(
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    mainAxisExtent: 120,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final unit = levelUnits[index];
                                return UnitCard(unit: unit, isDark: isDark);
                              }, childCount: levelUnits.length),
                            ),
                          ),
                        );
                      }

                      return SliverMainAxisGroup(slivers: slivers);
                    },
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, stack) => SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Error: $err',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Error: $err',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteHouseConfirmation(
    BuildContext context,
    WidgetRef ref,
    String propertyName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete House'),
        content: Text(
          'Are you sure you want to delete "$propertyName"? All units and data associated with this house will be disconnected. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(propertyRepositoryProvider)
                  .deleteProperty(propertyId);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                context.pop(); // Go back to properties list
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
