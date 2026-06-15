import 'package:barivara/features/renters/repositories/renter_repository.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barivara/shared/providers/home_providers.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:barivara/shared/services/cloudinary_service.dart';

class RenterHistoryPage extends ConsumerWidget {
  final String propertyId;
  final String unitId;
  final String? unitName;

  const RenterHistoryPage({
    super.key,
    required this.propertyId,
    required this.unitId,
    this.unitName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(
      renterHistoryStreamProvider((propertyId, unitId)),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MaxWidthContainer(
          child: AppBar(
            title: Text(
              unitName != null ? 'History: $unitName' : 'Renter History',
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: MaxWidthContainer(
        child: historyAsync.when(
          data: (history) {
            if (history.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      'No past tenants found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Historical records will appear here after tenants move out.',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final renter = history[index];
                return _buildHistoryCard(context, ref, renter, isDark);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    WidgetRef ref,
    dynamic renter,
    bool isDark,
  ) {
    final moveIn = DateFormat('MMM d, yyyy').format(renter.moveInDate);
    final moveOut = renter.moveOutDate != null
        ? DateFormat('MMM d, yyyy').format(renter.moveOutDate!)
        : 'Unknown';

    final duration = renter.moveOutDate != null
        ? _calculateDuration(renter.moveInDate, renter.moveOutDate!)
        : 'Unknown';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.1),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(
                    0xFF6366F1,
                  ).withValues(alpha: 0.1),
                  child: Text(
                    renter.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF6366F1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        renter.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (renter.occupation != null)
                        Text(
                          renter.occupation!,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ARCHIVED',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onSelected: (value) async {
                    if (value == 'view') {
                      context.push(
                        '/landlord/properties/$propertyId/units/$unitId/renter-details/${renter.id}',
                      );
                    } else if (value == 'edit') {
                      context.push(
                        '/landlord/properties/$propertyId/units/$unitId/edit-renter/${renter.id}',
                      );
                    } else if (value == 'restore') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Restore Renter'),
                          content: Text(
                            'Are you sure you want to restore ${renter.name} as the active renter for this unit? This will mark the unit as occupied.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Restore'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await ref
                            .read(renterRepositoryProvider)
                            .restoreRenter(propertyId, unitId, renter.id);
                        if (context.mounted) {
                          final messenger = ScaffoldMessenger.of(context);
                          messenger.showSnackBar(
                            SnackBar(
                              duration: const Duration(minutes: 5),
                              content: const Text('Renter restored successfully!'),
                              action: SnackBarAction(
                                label: '✕',
                                textColor: Colors.white,
                                onPressed: () => messenger.hideCurrentSnackBar(),
                              ),
                            ),
                          );
                        }
                      }
                    } else if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete History'),
                          content: Text(
                            'Are you sure you want to permanently delete the history record for ${renter.name}? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        if (!context.mounted) return;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text('Deleting historical record and files...'),
                              ],
                            ),
                          ),
                        );

                        try {
                          // 1. Delete Images
                          final List<String> urlsToDelete = [];
                          if (renter.photoUrl != null) {
                            urlsToDelete.add(renter.photoUrl!);
                          }
                          for (final member in renter.familyMembers) {
                            if (member.photoUrl != null) {
                              urlsToDelete.add(member.photoUrl!);
                            }
                            for (final doc in member.documents) {
                              urlsToDelete.add(doc.url);
                            }
                          }
                          for (final doc in renter.documents) {
                            urlsToDelete.add(doc.url);
                          }
                          for (final url in urlsToDelete) {
                            await CloudinaryService.deleteImage(url);
                          }

                          // 2. Delete from DB
                          await ref
                              .read(renterRepositoryProvider)
                              .deleteRenter(propertyId, unitId, renter.id);

                          if (context.mounted) {
                            Navigator.pop(context); // Close progress
                            final messenger = ScaffoldMessenger.of(context);
                            messenger.showSnackBar(
                              SnackBar(
                                duration: const Duration(minutes: 5),
                                content: const Text(
                                  'History record and files deleted!',
                                ),
                                action: SnackBarAction(
                                  label: '✕',
                                  textColor: Colors.white,
                                  onPressed: () => messenger.hideCurrentSnackBar(),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context); // Close progress
                            final messenger = ScaffoldMessenger.of(context);
                            messenger.showSnackBar(
                              SnackBar(
                                duration: const Duration(minutes: 5),
                                content: Text('Error deleting: $e'),
                                action: SnackBarAction(
                                  label: '✕',
                                  textColor: Colors.white,
                                  onPressed: () => messenger.hideCurrentSnackBar(),
                                ),
                              ),
                            );
                          }
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('View Details'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('Edit Info'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'restore',
                      child: Row(
                        children: [
                          Icon(
                            Icons.restore_outlined,
                            size: 20,
                            color: Color(0xFF6366F1),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Restore as Current',
                            style: TextStyle(color: Color(0xFF6366F1)),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Delete History',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoTile('Move In', moveIn, Icons.login_outlined),
                _infoTile('Move Out', moveOut, Icons.logout_outlined),
                _infoTile('Duration', duration, Icons.timer_outlined),
              ],
            ),
            if (renter.landlordNotes != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.note_alt_outlined,
                      size: 14,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        renter.landlordNotes!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final diff = end.difference(start);
    if (diff.inDays < 30) return '${diff.inDays} days';
    final months = (diff.inDays / 30).floor();
    if (months < 12) return '$months months';
    final years = (months / 12).floor();
    final remainingMonths = months % 12;
    if (remainingMonths == 0) return '$years years';
    return '$years yr $remainingMonths mo';
  }
}
