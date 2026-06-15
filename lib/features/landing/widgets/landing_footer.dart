import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingFooter extends StatelessWidget {
  final bool isDark;

  const LandingFooter({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home_work, color: Color(0xFF6366F1), size: 32),
              const SizedBox(width: 12),
              Text(
                'BariVara',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Modern property management and discovery platform.'),
          const SizedBox(height: 48),
          Wrap(
            spacing: 20,
            children: [
              TextButton(onPressed: () => context.go('/admin'), child: const Text('Admin')),
              TextButton(onPressed: () => context.go('/request-landlord'), child: const Text('List Property')),
              TextButton(onPressed: () {}, child: const Text('About Us')),
              TextButton(onPressed: () {}, child: const Text('Privacy Policy')),
            ],
          ),
          const SizedBox(height: 48),
          Text('©${DateTime.now().year} BariVara. All rights reserved.', style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }
}
