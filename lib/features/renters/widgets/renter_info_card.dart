import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/renter.dart';

class RenterInfoCard extends StatelessWidget {
  final Renter renter;
  final String propertyId;
  final String unitId;
  final bool isDark;

  static const _primaryColor = Color(0xFF6366F1);

  const RenterInfoCard({
    super.key,
    required this.renter,
    required this.propertyId,
    required this.unitId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        '/landlord/properties/$propertyId/units/$unitId/renter-details/${renter.id}',
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
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
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _primaryColor.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: _primaryColor,
                    size: 28,
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          renter.occupation ?? 'Renter',
                          style: const TextStyle(
                            color: _primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _phoneAction(Icons.phone_rounded, () => _launchPhone(context, renter.phone)),
                const SizedBox(width: 4),
                _phoneAction(Icons.chat_rounded, () => _launchWhatsApp(context, renter.phone)),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _compactStat(Icons.calendar_today_outlined, 'Moved in', DateFormat('MMM yyyy').format(renter.moveInDate)),
                const SizedBox(width: 24),
                _compactStat(Icons.account_balance_wallet_outlined, 'Advance', '৳${renter.advanceDeposit}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _phoneAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: _primaryColor),
      ),
    );
  }

  Widget _compactStat(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Future<void> _launchPhone(BuildContext context, String phone) async {
    final uri = Uri.parse('tel:${phone.replaceAll(RegExp(r'[^\d+]'), '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
