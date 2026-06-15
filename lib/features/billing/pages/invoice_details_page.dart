import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/providers/home_providers.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../models/invoice.dart';
import '../utils/invoice_pdf_generator.dart';
import '../../renters/repositories/renter_repository.dart';

class InvoiceDetailsPage extends ConsumerStatefulWidget {
  final String invoiceId;
  final String propertyId;
  final String unitId;
  final String? propertyName;
  final String? unitName;

  const InvoiceDetailsPage({
    super.key,
    required this.invoiceId,
    required this.propertyId,
    required this.unitId,
    this.propertyName,
    this.unitName,
  });

  @override
  ConsumerState<InvoiceDetailsPage> createState() =>
      _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends ConsumerState<InvoiceDetailsPage> {
  final _selectedItems = <String>{};
  final _removingItems = <String>{};
  bool _isRecording = false;

  Invoice get invoice => _invoice!;

  Invoice? _invoice;

  @override
  Widget build(BuildContext context) {
    final invoiceAsync = ref.watch(invoiceStreamProvider(widget.invoiceId));

    return invoiceAsync.when(
      data: (invoice) {
        _invoice = invoice;
        if (_selectedItems.isEmpty && invoice.payments.isEmpty) {
          _selectedItems.addAll(invoice.unpaidItemNames);
        }
        return _buildPage(invoice);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Invoice Details')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Invoice Details')),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildPage(Invoice invoice) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(invoice.displayStatus);
    const primaryColor = Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MaxWidthContainer(
          child: AppBar(
            title: Text(
              invoice.monthYear,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: MaxWidthContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER: Status Badge + Renter ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            invoice.displayStatus.toUpperCase(),
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
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          invoice.renterName ?? 'Unassigned',
                          style: TextStyle(
                            color: invoice.renterName != null
                                ? Colors.grey[600]
                                : Colors.orange[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.07)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '#${invoice.id}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[500],
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const SizedBox(height: 8),

                // --- BREAKDOWN TABLE ---
                _sectionLabel('Charges'),
                const SizedBox(height: 12),
                Table(
                  border: TableBorder.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey[300]!,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      children: [
                        _cell('Item', isBold: true),
                        _cell('Amount', isBold: true, alignRight: true),
                        _cell('Status', isBold: true, alignRight: true),
                      ],
                    ),
                    for (final name in invoice.chargeNames)
                      _buildChargeRow(name, isDark),
                    // TOTAL row
                    TableRow(
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(8),
                        ),
                      ),
                      children: [
                        _cell(
                          'TOTAL',
                          isBold: true,
                          color: primaryColor,
                        ),
                        _cell(
                          '৳${invoice.totalAmount}',
                          isBold: true,
                          color: primaryColor,
                          alignRight: true,
                        ),
                        _cell(
                          _selectedItems.isNotEmpty
                              ? 'Selected: ৳$_selectedTotal'
                              : '৳${invoice.paidAmount} paid',
                          isBold: true,
                          fontSize: 12,
                          color: _selectedItems.isNotEmpty
                              ? const Color(0xFF10B981)
                              : Colors.grey[500],
                          alignRight: true,
                        ),
                      ],
                    ),
                  ],
                ),

                // --- RECORD PAYMENT ---
                if (_selectedItems.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isRecording
                          ? null
                          : () => _recordPayment(context),
                      icon: _isRecording
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline, size: 18),
                      label: Text(
                        _isRecording
                            ? 'Recording...'
                            : _selectedItems.length ==
                                    invoice.unpaidItemNames.length
                                ? 'Pay All — ৳$_selectedTotal'
                                : 'Pay ৳$_selectedTotal',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],

                if (invoice.payments.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _clearPayments(context),
                      icon: const Icon(Icons.undo_rounded, size: 16),
                      label: const Text('Clear all payments'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[400],
                        side: BorderSide(color: Colors.red[200]!),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // --- PAYMENT HISTORY ---
                _sectionLabel('Payment History'),
                const SizedBox(height: 12),
                _logEntry(
                  icon: Icons.receipt_long_rounded,
                  title: 'Invoice created',
                  subtitle: invoice.createdAt != null
                      ? DateFormat('dd MMM, yyyy').format(invoice.createdAt!)
                      : 'N/A',
                  color: Colors.grey[500]!,
                ),
                if (invoice.payments.isNotEmpty)
                  ...invoice.payments.asMap().entries.map((entry) {
                    final p = entry.value;
                    return Padding(
                      key: ValueKey('payment-${entry.key}'),
                      padding: EdgeInsets.only(
                        top: entry.key == 0 ? 0 : 12,
                      ),
                      child: _logEntry(
                        icon: Icons.check_circle_rounded,
                        title: 'Paid ৳${p.amount}',
                        subtitle:
                            '${p.paidItems.isEmpty ? 'All items' : p.paidItems.join(', ')} · ${DateFormat('dd MMM, yyyy').format(p.paidAt)}',
                        color: const Color(0xFF10B981),
                        trailing: p.note != null
                            ? Text(
                                p.note!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              )
                            : null,
                      ),
                    );
                  }),
                const SizedBox(height: 28),

                // --- ACTIONS ---
                _sectionLabel('Actions'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        onPressed: () => _generatePdf(context),
                        icon: Icons.picture_as_pdf_outlined,
                        label: 'PDF',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _actionButton(
                        onPressed: () => _invoiceLink(context),
                        icon: Icons.link_rounded,
                        label: 'Link',
                        color: Colors.orange,
                      ),
                    ),
                    Expanded(
                      child: _actionButton(
                        onPressed: () => SharePlus.instance.share(
                          invoice.toShareMessage() as ShareParams,
                        ),
                        icon: Icons.share_rounded,
                        label: 'Share',
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _iconAction(
                        onPressed: () {
                          context.pop();
                          context.push(
                            '/landlord/properties/${widget.propertyId}/units/${widget.unitId}/edit-bill/${invoice.id}',
                            extra: invoice,
                          );
                        },
                        icon: Icons.edit_outlined,
                        color: Colors.grey[600]!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _iconAction(
                        onPressed: () => _handleDelete(context),
                        icon: Icons.delete_outline_rounded,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- CHARGE ROW WITH TAP TO SELECT ---

  TableRow _buildChargeRow(String name, bool isDark) {
    final isPaid = invoice.isItemPaid(name);
    final amount = invoice.chargeAmount(name);
    final isSelected = _selectedItems.contains(name);
    final canSelect = !isPaid && !_isRecording;

    void toggle() {
      if (!canSelect) return;
      setState(() {
        if (isSelected) {
          _selectedItems.remove(name);
        } else {
          _selectedItems.add(name);
        }
      });
    }

    return TableRow(
      children: [
        GestureDetector(
          onTap: toggle,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            color: isSelected && !isPaid
                ? const Color(0xFF10B981).withValues(alpha: 0.06)
                : null,
            child: Row(
              children: [
                if (canSelect)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : Colors.grey[400],
                    ),
                  ),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: isPaid ? const Color(0xFF10B981) : null,
                      fontSize: 13,
                      fontWeight: isPaid
                          ? FontWeight.w700
                          : isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                      decoration: isPaid ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: toggle,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            color: isSelected && !isPaid
                ? const Color(0xFF10B981).withValues(alpha: 0.06)
                : null,
            child: Text(
              '৳$amount',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: isPaid
                    ? const Color(0xFF10B981)
                    : isSelected
                        ? const Color(0xFF10B981)
                        : null,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: toggle,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            color: isSelected && !isPaid
                ? const Color(0xFF10B981).withValues(alpha: 0.06)
                : null,
            child: isPaid
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      const Text('Paid', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                      const SizedBox(width: 6),
                      if (_removingItems.contains(name))
                        const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      else
                        GestureDetector(
                          onTap: () => _confirmUndoItem(context, name),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded, size: 14, color: Colors.red),
                          ),
                        ),
                    ],
                  )
                : isSelected
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 10, color: Color(0xFF10B981)),
                          SizedBox(width: 4),
                          Text('Ready', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                        ],
                      )
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xFF10B981);
      case 'unpaid':
        return const Color(0xFFEF4444);
      case 'due':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  int get _selectedTotal =>
      _selectedItems.fold(0, (total, n) => total + invoice.chargeAmount(n));

  Future<void> _recordPayment(BuildContext context) async {
    setState(() => _isRecording = true);
    try {
      final paidItems = _selectedItems.toList();
      await ref.read(renterRepositoryProvider).recordPayment(
            invoiceId: invoice.id,
            amount: _selectedTotal,
            paidAt: DateTime.now(),
            paidItems: paidItems,
          );
      if (context.mounted) {
        setState(() {
          _isRecording = false;
          _selectedItems.clear();
        });
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Row(
              children: [
                Expanded(child: Text('Payment of ৳$_selectedTotal recorded!')),
                GestureDetector(
                  onTap: () => messenger.hideCurrentSnackBar(),
                  child: const Icon(Icons.close, size: 20, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () async {
                for (final item in paidItems) {
                  try {
                    await ref
                        .read(renterRepositoryProvider)
                        .removePaidItem(invoice.id, item);
                  } catch (_) {}
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        setState(() => _isRecording = false);
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

  // --- HELPERS ---

  Widget _cell(
    String text, {
    bool isBold = false,
    Color? color,
    double? fontSize,
    TextDecoration? decoration,
    FontWeight? fontWeight,
    bool alignRight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.start,
        style: TextStyle(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? (isBold ? FontWeight.bold : FontWeight.w500),
          color: color,
          decoration: decoration,
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6366F1),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _logEntry({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }

  Widget _actionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconAction({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }

  // --- ACTIONS ---

  void _generatePdf(BuildContext context) async {
    try {
      final generator = InvoicePdfGenerator();
      await generator.generateAndShare(
        invoice,
        propertyName: widget.propertyName,
        unitName: widget.unitName,
      );
    } catch (e) {
      if (context.mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error generating PDF: $e'),
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

  void _invoiceLink(BuildContext context) {
    context.go('/invoice/${invoice.id}');
  }

  Future<void> _clearPayments(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Unpaid'),
        content: const Text(
          'Clear all payment records and mark as unpaid? This cannot be undone.',
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
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(renterRepositoryProvider)
            .clearPayments(invoice.id);
        if (context.mounted) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(minutes: 5),
              content: const Text('Payments cleared, invoice is unpaid'),
              backgroundColor: const Color(0xFF6366F1),
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

  Future<void> _confirmUndoItem(BuildContext context, String itemName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mark $itemName as unpaid?'),
        content: Text(
          'This will remove $itemName from the payment record.',
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
            child: const Text('Undo'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      _removePaidItem(context, itemName);
    }
  }

  Future<void> _removePaidItem(BuildContext context, String itemName) async {
    setState(() => _removingItems.add(itemName));
    try {
      await ref
          .read(renterRepositoryProvider)
          .removePaidItem(invoice.id, itemName);
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
    if (context.mounted) setState(() => _removingItems.remove(itemName));
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content:
            const Text('This action cannot be undone. Are you sure?'),
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
      try {
        await ref
            .read(renterRepositoryProvider)
            .deleteInvoice(invoice.id);
        if (context.mounted) {
          context.pop();
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(minutes: 5),
              content: const Text('Invoice deleted'),
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
}
