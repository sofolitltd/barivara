import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/rent_post.dart';

class PropertyCard extends ConsumerWidget {
  final RentPost post;
  final bool isDark;

  const PropertyCard({super.key, required this.post, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return InkWell(
      onTap: () => context.go('/post/${post.id}'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.1),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            post.imageUrls.isNotEmpty
                ? Image.network(
                    post.imageUrls.first,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, _) => Container(
                      height: 220,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  )
                : Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey[200],
                    ),
                    child: Icon(
                      Icons.home_work_outlined,
                      size: 48,
                      color: isDark ? Colors.grey[700] : Colors.grey[400],
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Text(
                        NumberFormat.currency(
                          symbol: '৳',
                          decimalDigits: 0,
                        ).format(post.rentAmount),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      const Text(
                        '/month',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconInfo(Icons.bed_outlined, '${post.beds ?? 0} Beds'),
                      _iconInfo(
                        Icons.bathtub_outlined,
                        '${post.baths ?? 0} Baths',
                      ),
                      _iconInfo(
                        Icons.square_foot_outlined,
                        post.areaSqft ?? 'N/A',
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

  Widget _iconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      ],
    );
  }

}
