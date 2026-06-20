import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/shared/providers/home_providers.dart';

class UnpaidInvoicesPage extends ConsumerWidget {
  final String ownerId;

  const UnpaidInvoicesPage({super.key, required this.ownerId});

  Color _statusColor(String status) {
    switch (status) {
      case 'due':
        return Colors.orange;
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'due':
        return Icons.pending_rounded;
      case 'unpaid':
        return Icons.error_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(unpaidInvoicesProvider(ownerId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Unpaid Invoices')),
      body: invoicesAsync.when(
        data: (invoices) {
          if (invoices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('All invoices paid!', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                ],
              ),
            );
          }
          final sorted = invoices.toList()..sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final invoice = sorted[index];
              final ds = invoice.displayStatus;
              return Material(
                type: MaterialType.transparency,
                child: ListTile(
                  tileColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.12)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onTap: () => context.push('/landlord/properties/${invoice.propertyId}/units/${invoice.unitId}/invoice-details/${invoice.id}'),
                  leading: Container(
                    height: 46, width: 46,
                    decoration: BoxDecoration(
                      color: _statusColor(ds).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_statusIcon(ds), color: _statusColor(ds), size: 20),
                  ),
                  title: Text(invoice.monthYear, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: -0.3)),
                  subtitle: Text(
                    '৳${invoice.totalAmount} · ${invoice.renterName ?? 'No Renter'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w600),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ds.toUpperCase(),
                        style: TextStyle(
                          color: _statusColor(ds),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
