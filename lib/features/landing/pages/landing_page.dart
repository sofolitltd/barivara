import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/shared/providers/home_providers.dart';
import '/shared/widgets/responsive_layout.dart';
import '/features/landing/widgets/landing_hero.dart';
import '/features/landing/widgets/property_card.dart';
import '/features/landing/widgets/features_section.dart';
import '/features/landing/widgets/landing_footer.dart';
import '/features/landing/widgets/landlord_cta_section.dart';

class SelectedPropertyType extends Notifier<String> {
  @override
  String build() => 'All Properties';

  void setType(String type) => state = type;
}

final selectedPropertyTypeProvider = NotifierProvider<SelectedPropertyType, String>(SelectedPropertyType.new);

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final postsAsync = ref.watch(allRentPostsStreamProvider);
    final selectedType = ref.watch(selectedPropertyTypeProvider);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    // Filter logic
    final filteredPostsAsync = postsAsync.whenData((posts) {
      if (selectedType == 'All Properties') return posts;
      return posts.where((p) => p.propertyType == selectedType).toList();
    });

    return SelectionArea(
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        body: MaxWidthContainer(
          child: CustomScrollView(
            slivers: [
              // --- HERO SECTION ---
              SliverToBoxAdapter(
                child: LandingHero(isDark: isDark, isDesktop: isDesktop),
              ),


              // --- LANDLORD CTA SECTION ---
              const SliverToBoxAdapter(
                child: LandlordCtaSection(),
              ),
              
              // --- FILTER CHIPS ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        _filterChip(ref, 'All Properties', selectedType == 'All Properties', isDark),
                        _filterChip(ref, 'Apartments', selectedType == 'Apartments', isDark),
                        _filterChip(ref, 'Studios', selectedType == 'Studios', isDark),
                        _filterChip(ref, 'Office Space', selectedType == 'Office Space', isDark),
                      ],
                    ),
                  ),
                ),
              ),

              // --- PROPERTY LISTINGS ---
              filteredPostsAsync.when(
                data: (posts) => posts.isEmpty 
                  ? const SliverFillRemaining(child: Center(child: Text('No properties found for this category.')))
                  : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 3 : (ResponsiveLayout.isTablet(context) ? 2 : 1),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      mainAxisExtent: 440,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => PropertyCard(post: posts[index], isDark: isDark),
                      childCount: posts.length,
                    ),
                  ),
                ),
                loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                error: (e, _) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
              ),


              // --- WHY CHOOSE US SECTION ---
              const SliverToBoxAdapter(
                child: FeaturesSection(),
              ),

              // --- FOOTER ---
              SliverToBoxAdapter(
                child: LandingFooter(isDark: isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(WidgetRef ref, String label, bool isSelected, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          ref.read(selectedPropertyTypeProvider.notifier).setType(label);
        },
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        selectedColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
        checkmarkColor: const Color(0xFF6366F1),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF6366F1) : (isDark ? Colors.grey[400] : Colors.grey[700]),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFF6366F1) : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.1)),
          ),
        ),
      ),
    );
  }
}
