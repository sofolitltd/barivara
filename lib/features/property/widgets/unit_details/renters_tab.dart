import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../renters/models/renter.dart';
import '../../../renters/widgets/renter_info_card.dart';
import 'common.dart';

class RentersTab extends StatelessWidget {
  final AsyncValue<List<Renter>> rentersAsync;
  final bool isDark;
  final String propertyId;
  final String unitId;

  const RentersTab({
    super.key,
    required this.rentersAsync,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSectionHeader('Current Renter', isDark),
              TextButton.icon(
                onPressed: () => context.push(
                  '/landlord/properties/$propertyId/units/$unitId/renter-history',
                ),
                icon: const Icon(Icons.history, size: 18),
                label: const Text('History'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          rentersAsync.when(
            data: (renters) {
              if (renters.isEmpty) {
                return buildEmptySection(
                  isDark: isDark,
                  icon: Icons.person_add_outlined,
                  title: 'No Active Renter',
                  subtitle:
                      'This unit is currently vacant. Add a renter to start managing billing and history.',
                  actionLabel: 'Add Renter',
                  onTap: () => context.push(
                    '/landlord/properties/$propertyId/units/$unitId/add-renter',
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...renters.map(
                    (renter) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RenterInfoCard(
                        renter: renter,
                        propertyId: propertyId,
                        unitId: unitId,
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.push(
                      '/landlord/properties/$propertyId/units/$unitId/add-renter',
                    ),
                    icon: const Icon(Icons.person_add_outlined, size: 20),
                    label: const Text('Add New Renter'),
                    style: ElevatedButton.styleFrom(
                    
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ],
      ),
    );
  }
}
