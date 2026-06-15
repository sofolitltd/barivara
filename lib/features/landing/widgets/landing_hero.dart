import 'package:flutter/material.dart';

class LandingHero extends StatelessWidget {
  final bool isDark;
  final bool isDesktop;

  const LandingHero({
    super.key,
    required this.isDark,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 100 : 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC)],
        ),
      ),
      child: Column(
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              '🏠 Trusted by 10k+ Landlords',
              style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Find Your Perfect\nHome in Minutes',
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 64 : 40,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1.5,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'The most modern way to find rent and manage properties.\nVerified listings, secure connections, and zero hassle.',
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          _buildHeroSearch(context, isDark, isDesktop),
        ],
      ),
    );
  }

  Widget _buildHeroSearch(BuildContext context, bool isDark, bool isDesktop) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, color: Color(0xFF6366F1)),
          const SizedBox(width: 12),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by location, property type...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          const SizedBox(width: 16),
          if (isDesktop) ...[
            const VerticalDivider(width: 1),
            const SizedBox(width: 16),
            const Icon(Icons.location_on_outlined, color: Colors.grey),
            const SizedBox(width: 8),
            const Text('Dhaka, BD', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 24),
          ],
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
