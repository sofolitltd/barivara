import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';

class LandlordCtaSection extends StatelessWidget {
  const LandlordCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context) || ResponsiveLayout.isTablet(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isDesktop ? 60 : 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you a Home Owner?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'List your property with us and reach thousands of verified renters. Quick, easy, and secure.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _ctaButton(
                context,
                'Register Now',
                Icons.add_home,
                () => context.go('/request-landlord'),
                true,
              ),
              const SizedBox(height: 16),
              _ctaButton(
                context,
                'Landlord Login',
                Icons.login,
                () => context.go('/login'),
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Are you a Home Owner?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'List your property with us and reach thousands of verified renters.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        _ctaButton(
          context,
          'Register Now',
          Icons.add_home,
          () => context.go('/request-landlord'),
          true,
        ),
        const SizedBox(height: 12),
        _ctaButton(
          context,
          'Landlord Login',
          Icons.login,
          () => context.go('/login'),
          false,
        ),
      ],
    );
  }

  Widget _ctaButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
    bool isPrimary,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: isPrimary ? const Color(0xFF6366F1) : Colors.white),
        label: Text(
          label,
          style: TextStyle(
            color: isPrimary ? const Color(0xFF6366F1) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.white : Colors.white.withValues(alpha: 0.15),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary ? BorderSide.none : const BorderSide(color: Colors.white24),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
