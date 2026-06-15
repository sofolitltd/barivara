import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/features/property/repositories/property_repository.dart';
import '../models/unit.dart';
import 'package:intl/intl.dart';

import '/shared/providers/home_providers.dart';

class UnitCard extends ConsumerWidget {
  final Unit unit;
  final bool isDark;

  const UnitCard({super.key, required this.unit, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6366F1);
    final isOwner = unit.status == 'owner';
    final statusColor = isOwner
        ? const Color(0xFF6366F1)
        : unit.isOccupied
            ? const Color(0xFF10B981)
            : const Color(0xFFF59E0B);

    final invoicesAsync = ref.watch(
      propertyInvoicesStreamProvider(unit.propertyId),
    );
    final rentersAsync = ref.watch(
      rentersStreamProvider((unit.propertyId, unit.id)),
    );

    return InkWell(
      onTap: () {
        context.go('/landlord/properties/${unit.propertyId}/units/${unit.id}?tab=renter');
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.1),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          children: [
            // --- Unit Image / Icon ---
            Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: unit.imageUrl == null
                    ? LinearGradient(
                        colors: [
                          primaryColor.withValues(alpha: 0.8),
                          primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                image: unit.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(unit.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: unit.imageUrl == null
                  ? const Icon(
                      Icons.door_front_door_outlined,
                      color: Colors.white,
                      size: 32,
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // --- Unit Info ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        '${unit.unitNumber} ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      if (!isOwner)
                        invoicesAsync.when(
                        data: (invoices) {
                          final unitInvoices = invoices
                              .where((i) => i.unitId == unit.id)
                              .toList();
                          final hasDue = unitInvoices.any(
                            (i) =>
                                i.displayStatus == 'unpaid' ||
                                i.displayStatus == 'due',
                          );

                          if (hasDue) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'DUE',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (isOwner)
                    Text(
                      'Owner',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    )
                  else
                    rentersAsync.when(
                      data: (renters) {
                        final tenantName =
                            renters.isNotEmpty ? renters.first.name : null;
                        return Text(
                          tenantName != null
                              ? '৳ ${unit.totalRent}  ·  $tenantName'
                              : '৳ ${unit.totalRent}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        );
                      },
                      loading: () => Text(
                        '৳ ${unit.totalRent}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      error: (_, _) => Text(
                        '৳ ${unit.totalRent}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isOwner
                              ? 'Owner'
                              : unit.isOccupied
                                  ? 'Occupied'
                                  : 'Vacant',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      if (unit.isOccupied && !isOwner)
                        invoicesAsync.when(
                          data: (invoices) {
                            final now = DateTime.now();
                            final monthYear = DateFormat(
                              'MMMM yyyy',
                            ).format(now);
                            final hasBilling = invoices.any(
                              (i) =>
                                  i.unitId == unit.id &&
                                  i.monthYear == monthYear,
                            );

                            if (now.day >= 7 && !hasBilling) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.notification_important_outlined,
                                      size: 10,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Needs Billing',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // --- Actions ---
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.go(
                        '/landlord/properties/${unit.propertyId}/units/${unit.id}/edit-unit',
                      );
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, ref);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit Unit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete Unit',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Unit'),
        content: Text(
          'Are you sure you want to delete unit ${unit.unitNumber}? This action cannot be undone.',
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
                  .deleteUnit(unit.propertyId, unit.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
