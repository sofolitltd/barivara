import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../billing/models/invoice.dart';
import '../../../billing/widgets/invoice_list_tile.dart';
import '../../../renters/repositories/renter_repository.dart';
import 'common.dart';

class BillingTab extends ConsumerWidget {
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

  void _deleteInvoice(BuildContext context, WidgetRef ref, Invoice invoice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Invoice', style: TextStyle(color: Colors.red)),
        content: Text('Delete invoice for ${invoice.monthYear} (#${invoice.invoiceNumber.isNotEmpty ? invoice.invoiceNumber : invoice.id.substring(0, 6)})? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(renterRepositoryProvider).deleteInvoice(invoice.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Invoice #${invoice.invoiceNumber.isNotEmpty ? invoice.invoiceNumber : invoice.id.substring(0, 6)} deleted'),
            action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error deleting: $e'),
            action: SnackBarAction(label: '✕', textColor: Colors.white, onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                onPressed: () async {
                  final repo = ref.read(renterRepositoryProvider);
                  final hasRenter = await repo.hasActiveRenter(propertyId, unitId);
                  if (!context.mounted) return;
                  if (!hasRenter) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('No Active Renter'),
                        content: const Text(
                          'This unit doesn\'t have an active renter. Please add a renter first before creating a bill.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  context.push(
                    '/landlord/properties/$propertyId/units/$unitId/add-bill',
                  );
                },
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
                  onTap: () async {
                    final repo = ref.read(renterRepositoryProvider);
                    final hasRenter = await repo.hasActiveRenter(propertyId, unitId);
                    if (!context.mounted) return;
                    if (!hasRenter) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('No Active Renter'),
                          content: const Text(
                            'This unit doesn\'t have an active renter. Please add a renter first before creating a bill.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    context.push(
                      '/landlord/properties/$propertyId/units/$unitId/add-bill',
                    );
                  },
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
                    onEdit: () => context.push(
                      '/landlord/properties/$propertyId/units/$unitId/edit-bill/${invoice.id}',
                      extra: invoice,
                    ),
                    onDelete: () => _deleteInvoice(context, ref, invoice),
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
