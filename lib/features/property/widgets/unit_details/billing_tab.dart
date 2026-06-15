import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../billing/models/invoice.dart';
import '../../../billing/widgets/invoice_list_tile.dart';
import 'common.dart';

class BillingTab extends StatelessWidget {
  final AsyncValue<List<Invoice>> invoicesAsync;
  final bool isDark;
  final String propertyId;
  final String unitId;
  final String? propertyName;
  final String? unitName;

  const BillingTab({
    super.key,
    required this.invoicesAsync,
    required this.isDark,
    required this.propertyId,
    required this.unitId,
    this.propertyName,
    this.unitName,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.red;
      case 'due':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle_rounded;
      case 'unpaid':
        return Icons.error_outline_rounded;
      case 'due':
        return Icons.pending_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

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
              buildSectionHeader('Recent Invoices', isDark),
              TextButton.icon(
                onPressed: () => context.push(
                  '/landlord/properties/$propertyId/units/$unitId/add-bill',
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Bill'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          invoicesAsync.when(
            data: (invoices) {
              if (invoices.isEmpty) {
                return buildEmptySection(
                  isDark: isDark,
                  icon: Icons.receipt_long_outlined,
                  title: 'No Invoices Yet',
                  subtitle: 'Bills generated for this unit will appear here.',
                  actionLabel: 'Create First Bill',
                  onTap: () => context.push(
                    '/landlord/properties/$propertyId/units/$unitId/add-bill',
                  ),
                );
              }
              return Column(
                children: invoices.map<Widget>((invoice) {
                  final ds = invoice.displayStatus;
                  return InvoiceListTile(
                    invoice: invoice,
                    isDark: isDark,
                    statusColor: _getStatusColor(ds),
                    statusIcon: _getStatusIcon(ds),
                    onTap: () => context.push(
                      '/landlord/properties/$propertyId/units/$unitId/invoice-details/${invoice.id}',
                    ),
                  );
                }).toList(),
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
