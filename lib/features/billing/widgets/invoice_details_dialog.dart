import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/invoice.dart';
import '../utils/invoice_pdf_generator.dart';
import '../../renters/repositories/renter_repository.dart';

class InvoiceDetailsDialog extends ConsumerStatefulWidget {
  final Invoice invoice;
  final String propertyId;
  final String unitId;
  final String? propertyName;
  final String? unitName;

  const InvoiceDetailsDialog({
    super.key,
    required this.invoice,
    required this.propertyId,
    required this.unitId,
    this.propertyName,
    this.unitName,
  });

  @override
  ConsumerState<InvoiceDetailsDialog> createState() =>
      _InvoiceDetailsDialogState();
}

class _InvoiceDetailsDialogState extends ConsumerState<InvoiceDetailsDialog> {
  final _selectedItems = <String>{};
  final _noteController = TextEditingController();
  late DateTime _paymentDate;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _paymentDate = DateTime.now();
    _selectedItems.addAll(widget.invoice.unpaidItemNames);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Invoice get invoice => widget.invoice;

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
      _selectedItems.fold(0, (sum, n) => sum + invoice.chargeAmount(n));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayStatus = invoice.displayStatus;
    final statusColor = _getStatusColor(displayStatus);
    final propertyId = widget.propertyId;
    final unitId = widget.unitId;
    const primaryColor = Color(0xFF6366F1);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 420,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
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
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          displayStatus.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),

            // --- INFO ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    invoice.monthYear,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 13,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        invoice.renterName ?? 'Unassigned',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: invoice.renterName != null
                              ? Colors.grey[500]
                              : Colors.orange[400],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
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
                            fontSize: 10,
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
            ),

            const SizedBox(height: 20),

            // --- BREAKDOWN + PAYMENT ---
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // --- BREAKDOWN TABLE ---
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
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Item',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Amount',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Status',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
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
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'TOTAL',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                '৳${invoice.totalAmount}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                '৳${invoice.paidAmount} paid',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: invoice.paidAmount >=
                                          invoice.totalAmount
                                      ? const Color(0xFF10B981)
                                      : Colors.grey[500],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // --- PAYMENT SECTION ---
                    if (invoice.unpaidItemNames.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildPaymentSection(isDark),
                    ],

                    const SizedBox(height: 20),

                    // --- DETAILS ---
                    _buildSectionHeader('Details'),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.calendar_today_rounded,
                      'Created',
                      invoice.createdAt != null
                          ? DateFormat(
                              'dd MMM, yyyy',
                            ).format(invoice.createdAt!)
                          : 'N/A',
                    ),
                    if (invoice.paidAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _buildDetailRow(
                          Icons.verified_rounded,
                          'Paid',
                          DateFormat('dd MMM, yyyy').format(invoice.paidAt!),
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- ACTIONS ---
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.02)
                    : Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white10 : Colors.grey[200]!,
                  ),
                ),
              ),
              child: Column(
                children: [
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
                      const SizedBox(width: 8),
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
                        flex: 2,
                        child: Container(
                          height: 44,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: statusColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                displayStatus.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: [
                            _iconAction(
                              onPressed: () {
                                Navigator.pop(context);
                                context.push(
                                  '/landlord/properties/$propertyId/units/$unitId/edit-bill/${invoice.id}',
                                  extra: invoice,
                                );
                              },
                              icon: Icons.edit_outlined,
                              color: Colors.grey[600]!,
                            ),
                            const SizedBox(width: 8),
                            _iconAction(
                              onPressed: () =>
                                  _handleDelete(context),
                              icon: Icons.delete_outline_rounded,
                              color: const Color(0xFFEF4444),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CHARGE ROW WITH CHECKBOX ---

  TableRow _buildChargeRow(String name, bool isDark) {
    final isPaid = invoice.isItemPaid(name);
    final amount = invoice.chargeAmount(name);
    final isSelected = _selectedItems.contains(name);
    final canSelect = !isPaid && !_isRecording;

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            name,
            style: TextStyle(
              color: isPaid ? const Color(0xFF10B981) : null,
              fontSize: 13,
              fontWeight: isPaid ? FontWeight.w700 : FontWeight.w500,
              decoration: isPaid ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            '৳$amount',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: isPaid ? const Color(0xFF10B981) : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: isPaid
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (canSelect)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _selectedItems.add(name);
                              } else {
                                _selectedItems.remove(name);
                              }
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                    else
                      Text(
                        'Unpaid',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  // --- PAYMENT SECTION ---

  Widget _buildPaymentSection(bool isDark) {
    final canPay = _selectedItems.isNotEmpty;
    final propertyId = widget.propertyId;
    final unitId = widget.unitId;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                size: 16,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              Text(
                canPay
                    ? 'Record Payment (${_selectedItems.length} item${_selectedItems.length > 1 ? 's' : ''})'
                    : 'Select items to record payment',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          if (canPay) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  for (final name in _selectedItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '৳${invoice.chargeAmount(name)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '৳$_selectedTotal',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _paymentDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _paymentDate = date);
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Payment Date',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  DateFormat('dd MMM, yyyy').format(_paymentDate),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'e.g. Rent only',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isRecording
                    ? null
                    : () => _recordPayment(
                          context,
                          ref,
                          propertyId,
                          unitId,
                        ),
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
                  _isRecording ? 'Recording...' : 'Confirm Payment',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _recordPayment(
    BuildContext context,
    WidgetRef ref,
    String propertyId,
    String unitId,
  ) async {
    setState(() => _isRecording = true);
    try {
      await ref.read(renterRepositoryProvider).recordPayment(
            invoiceId: invoice.id,
            amount: _selectedTotal,
            paidAt: _paymentDate,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            paidItems: _selectedItems.toList(),
          );
      if (context.mounted) {
        Navigator.pop(context);
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text(
              'Payment of ৳$_selectedTotal recorded!',
            ),
            backgroundColor: const Color(0xFF10B981),
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

  // --- EXISTING HELPER WIDGETS ---

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: Container(height: 1, color: Colors.grey[200])),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (color ?? Colors.grey[400]!).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 16, color: color ?? Colors.grey[500]),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
          padding: const EdgeInsets.symmetric(vertical: 10),
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

  // --- EXISTING METHODS ---

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
          Navigator.pop(context);
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
