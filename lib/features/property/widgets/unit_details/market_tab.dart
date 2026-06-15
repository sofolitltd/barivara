import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../landing/models/rent_post.dart';
import '../../../landing/repositories/listing_repository.dart';
import '../../models/unit.dart';
import 'common.dart';

class MarketTab extends StatelessWidget {
  final AsyncValue<RentPost?> listingAsync;
  final Unit unit;
  final bool isDark;
  final String propertyId;
  final String unitId;

  const MarketTab({
    super.key,
    required this.listingAsync,
    required this.unit,
    required this.isDark,
    required this.propertyId,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionHeader('Marketplace Listing', isDark),
          const SizedBox(height: 16),
          listingAsync.when(
            data: (listing) {
              if (listing == null) {
                if (unit.isOccupied || unit.status == 'owner') {
                  return _buildInfoCard(
                    'Unit is currently occupied. Listings are only for vacant units.',
                    Icons.info_outline,
                  );
                }
                return buildEmptySection(
                  isDark: isDark,
                  icon: Icons.campaign_outlined,
                  title: 'Not Advertised',
                  subtitle:
                      'This unit is not currently listed on the marketplace.',
                  actionLabel: 'Create Listing',
                  onTap: () => context.push(
                    '/landlord/properties/$propertyId/units/$unitId/add-listing',
                  ),
                );
              }
              return _buildListingCard(context, listing, isDark);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildListingCard(
    BuildContext context,
    RentPost listing,
    bool isDark,
  ) {
    return Consumer(
      builder: (context, ref, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: listing.imageUrls.isNotEmpty
                        ? Image.network(
                            listing.imageUrls.first,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '৳${listing.rentAmount} / month',
                          style: const TextStyle(
                            color: Color(0xFF6366F1),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(
                        '/landlord/properties/${listing.propertyId}/units/${listing.unitId}/edit-listing/${listing.id}',
                      ),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Listing'),
                            content: const Text(
                              'Are you sure you want to remove this listing from the marketplace?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await ref
                              .read(listingRepositoryProvider)
                              .deleteRentPost(listing.id!);
                          if (context.mounted) {
                            final messenger = ScaffoldMessenger.of(context);
                            messenger.showSnackBar(
                              SnackBar(
                                duration: const Duration(minutes: 5),
                                content: const Text('Listing removed'),
                                action: SnackBarAction(
                                  label: '✕',
                                  textColor: Colors.white,
                                  onPressed: () => messenger.hideCurrentSnackBar(),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
