import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/invoice.dart';

class InvoiceListTile extends StatelessWidget {
  final Invoice invoice;
  final bool isDark;
  final VoidCallback onTap;
  final Color statusColor;
  final IconData statusIcon;

  const InvoiceListTile({
    super.key,
    required this.invoice,
    required this.isDark,
    required this.onTap,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.12),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(statusIcon, color: statusColor, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                invoice.monthYear,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            // Short invoice number badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
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
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(Icons.person_outline, size: 12, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                invoice.renterName ?? 'No Renter',
                style: TextStyle(
                  color: invoice.renterName != null ? Colors.grey[600] : Colors.orange[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 4, width: 4,
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                invoice.payments.isNotEmpty
                    ? '৳${invoice.paidAmount}/৳${invoice.totalAmount}'
                    : '৳${invoice.totalAmount}',
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.share_outlined,
            size: 18,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          onPressed: () => SharePlus.instance.share(
            invoice.toShareMessage() as ShareParams,
          ),
          tooltip: 'Share Invoice',
        ),
      ),
    );
  }
}
