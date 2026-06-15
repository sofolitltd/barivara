import 'package:flutter/material.dart';

Widget buildSectionHeader(String title, bool isDark) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.5,
    ),
  );
}

Widget buildEmptySection({
  required bool isDark,
  required IconData icon,
  required String title,
  required String subtitle,
  required String actionLabel,
  required VoidCallback onTap,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.1),
      ),
    ),
    child: Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6366F1),
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
