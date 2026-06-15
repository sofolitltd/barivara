import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/providers/home_providers.dart';
import '../utils/invoice_pdf_generator.dart';
import '/shared/widgets/responsive_layout.dart';

class InvoiceViewPage extends ConsumerWidget {
  final String invoiceId;

  const InvoiceViewPage({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final invoiceAsync = ref.watch(invoiceFutureProvider(invoiceId));
    const primaryColor = Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Digital Invoice', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: MaxWidthContainer(
        child: Center(
          child: invoiceAsync.when(
            data: (invoice) {
              final displayStatus = invoice.displayStatus;
              final statusColor = _getStatusColor(displayStatus);
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 500,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // --- TOP LOGO / HEADER ---
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor.withValues(alpha: 0.2),
                                        primaryColor.withValues(alpha: 0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.receipt_long_rounded, color: primaryColor, size: 40),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  invoice.monthYear,
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        displayStatus.toUpperCase(),
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 1),

                          // --- BILL DETAILS ---
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailItem('Billed To', invoice.renterName ?? 'Valued Tenant', Icons.person_outline),
                                const SizedBox(height: 16),
                                _buildDetailItem('Invoice Date', invoice.createdAt != null ? DateFormat('dd MMM, yyyy').format(invoice.createdAt!) : 'N/A', Icons.calendar_today_outlined),
                                const SizedBox(height: 24),
                                _buildDetailItem('Base Rent', '৳${invoice.baseRent}', Icons.home_work_outlined),
                                ...invoice.utilities.entries.map((e) => Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: _buildDetailItem(e.key, '৳${e.value}', Icons.bolt_outlined),
                                )),
                                if (invoice.otherCharges > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: _buildDetailItem('Other Charges', '৳${invoice.otherCharges}', Icons.add_circle_outline),
                                  ),
                                
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Divider(height: 1),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    Text(
                                      '৳${invoice.totalAmount}',
                                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: primaryColor),
                                    ),
                                  ],
                                ),
                                if (invoice.payments.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  const Divider(height: 1),
                                  const SizedBox(height: 16),
                                  const Text('Payments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 12),
                                  ...invoice.payments.asMap().entries.map((entry) {
                                    final p = entry.value;
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: entry.key == invoice.payments.length - 1 ? 0 : 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF10B981)),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text('৳${p.amount}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                          ),
                                          Text(
                                            DateFormat('dd MMM, yyyy').format(p.paidAt),
                                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                          ),
                                          if (p.note != null) ...[
                                            const SizedBox(width: 8),
                                            Text(p.note!, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                                          ],
                                        ],
                                      ),
                                    );
                                  }),
                                  if (displayStatus != 'paid') ...[
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Remaining', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                        Text(
                                          '৳${invoice.remainingBalance}',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFEF4444)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),

                          // --- ACTIONS ---
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _downloadPdf(context, invoice),
                                    icon: const Icon(Icons.download_rounded),
                                    label: const Text('Download PDF Invoice', style: TextStyle(fontWeight: FontWeight.w900)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Generated by Barivara Digital Platform',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text('Invoice not found or deleted', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[400]),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid': return const Color(0xFF10B981);
      case 'unpaid': return const Color(0xFFEF4444);
      case 'due': return const Color(0xFFF59E0B);
      default: return Colors.grey;
    }
  }

  void _downloadPdf(BuildContext context, dynamic invoice) async {
    try {
      final generator = InvoicePdfGenerator();
      await generator.generateAndShare(invoice);
    } catch (e) {
      if (context.mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error: $e'),
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
