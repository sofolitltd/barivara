import 'package:flutter/material.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Why Choose BariVara?',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureItem(Icons.verified_user_outlined, 'Verified Landlords', 'Every owner is verified by our team.'),
              _buildFeatureItem(Icons.security_outlined, 'Secure Payments', 'Safe and transparent transaction history.'),
              _buildFeatureItem(Icons.support_agent_outlined, '24/7 Support', 'We are here to help you anytime.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String desc) {
    return SizedBox(
      width: 280,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 32),
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
