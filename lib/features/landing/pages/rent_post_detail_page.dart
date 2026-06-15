import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '/features/landing/models/rent_post.dart';
import '/features/auth/models/app_user.dart';
import '/shared/widgets/responsive_layout.dart';
import '/features/auth/providers/auth_providers.dart';
import '/shared/providers/home_providers.dart';

class RentPostDetailPage extends ConsumerWidget {
  final String postId;
  final RentPost? initialPost;

  const RentPostDetailPage({super.key, required this.postId, this.initialPost});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    // Use the provided post or fetch it by ID if null
    final postAsync = ref.watch(rentPostFutureProvider(postId));
    
    return postAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (fetchedPost) {
        final post = initialPost ?? fetchedPost;
        
        if (post == null) {
          return const Scaffold(body: Center(child: Text('Post not found')));
        }

        final landlordState = ref.watch(userProvider(post.landlordId));

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
            title: const Text('Property Details'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: MaxWidthContainer(
            maxWidth: 1200,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- IMAGE GALLERY ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: post.imageUrls.isNotEmpty
                        ? Image.network(
                            post.imageUrls.first,
                            height: isDesktop ? 500 : 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: isDesktop ? 500 : 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              Icons.home_work_outlined,
                              size: 80,
                              color: isDark ? Colors.grey[700] : Colors.grey[400],
                            ),
                          ),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- LEFT COLUMN: DETAILS ---
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFF6366F1), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  post.location,
                                  style: TextStyle(fontSize: 18, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            
                            // --- STATS ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _detailStat(Icons.bed_outlined, '${post.beds ?? 0} Bedrooms', isDark),
                                const SizedBox(width: 24),
                                _detailStat(Icons.bathtub_outlined, '${post.baths ?? 0} Bathrooms', isDark),
                                const SizedBox(width: 24),
                                _detailStat(Icons.square_foot_outlined, post.areaSqft ?? 'N/A', isDark),
                              ],
                            ),
                            
                            const SizedBox(height: 40),
                            const Text(
                              'Description',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              post.description,
                              style: TextStyle(
                                fontSize: 16, 
                                height: 1.6,
                                color: isDark ? Colors.grey[300] : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (isDesktop) const SizedBox(width: 48),

                      // --- RIGHT COLUMN: ACTIONS ---
                      if (isDesktop)
                        Expanded(
                          flex: 1,
                          child: _buildActionCard(context, post, landlordState, isDark),
                        ),
                    ],
                  ),
                  
                  if (!isDesktop) ...[
                    const SizedBox(height: 40),
                    _buildActionCard(context, post, landlordState, isDark),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailStat(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, RentPost post, AsyncValue<AppUser?> landlordState, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (!isDark) BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NumberFormat.currency(symbol: '৳', decimalDigits: 0).format(post.rentAmount),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF6366F1)),
          ),
          const Text('per month', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),
          
          landlordState.when(
            data: (landlord) {
              if (landlord == null) return const Text('Landlord info not available');
              return Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        backgroundImage: landlord.photoUrl != null ? NetworkImage(landlord.photoUrl!) : null,
                        child: landlord.photoUrl == null ? Text(landlord.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFF6366F1))) : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(landlord.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Text('Landlord', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchCaller(landlord.phone),
                      icon: const Icon(Icons.phone),
                      label: const Text('Call Landlord'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _launchMessenger(landlord.phone),
                      icon: const Icon(Icons.message),
                      label: const Text('Send Message'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: const BorderSide(color: Color(0xFF6366F1)),
                        foregroundColor: const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error loading landlord: $e'),
          ),
        ],
      ),
    );
  }

  void _launchCaller(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchMessenger(String phone) async {
    final Uri url = Uri.parse('sms:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
