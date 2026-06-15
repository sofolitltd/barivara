import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/property.dart';
import '../repositories/property_repository.dart';
import '/features/auth/providers/auth_providers.dart';
import '/shared/providers/home_providers.dart';
import '/shared/widgets/responsive_layout.dart';

class HomeManagementPage extends ConsumerWidget {
  const HomeManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    // --- Use real logged-in user's ID ---
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
      data: (user) {
        if (user == null) {
          // Should not happen due to router guard, but defensive
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => context.go('/login'),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final propertiesAsync = ref.watch(propertiesStreamProvider(user.uid));

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: MaxWidthContainer(
              child: AppBar(
                title: const Text('My Properties'),
                centerTitle: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  if (user.role == 'landlord')
                    IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () =>
                          context.go('/landlord/properties/add-property'),
                    ),
                ],
              ),
            ),
          ),
          body: MaxWidthContainer(
            child: propertiesAsync.when(
              data: (properties) {
                if (properties.isEmpty) {
                  return _buildEmptyState(
                    context,
                    isDark,
                    user.role == 'landlord',
                  );
                }

                if (isDesktop || ResponsiveLayout.isTablet(context)) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 2 : 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 135,
                    ),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      return _PropertyItem(property: property, isDark: isDark);
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _PropertyItem(property: property, isDark: isDark),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error loading properties: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, bool canAdd) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 80,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 24),
          const Text(
            'No properties yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first house to start managing rent.',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          if (canAdd) ...[
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/landlord/properties/add-property'),
              icon: const Icon(Icons.add),
              label: const Text('Add Property'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PropertyItem extends ConsumerWidget {
  final Property property;
  final bool isDark;

  const _PropertyItem({required this.property, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = const Color(0xFF6366F1);

    return InkWell(
      onTap: () => context.go('/landlord/properties/${property.id}/units'),
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
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          children: [
            // --- Property Image / Icon ---
            Hero(
              tag: 'property_image_${property.id}',
              child: Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: (property.imageUrl?.isEmpty ?? true)
                      ? LinearGradient(
                          colors: [
                            primaryColor.withValues(alpha: 0.8),
                            primaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  image: (property.imageUrl?.isNotEmpty ?? false)
                      ? DecorationImage(
                          image: NetworkImage(property.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (property.imageUrl?.isEmpty ?? true)
                    ? Icon(
                        _getPropertyIcon(property.propertyType),
                        color: Colors.white,
                        size: 32,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 16),

            // --- Property Info ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    property.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.address,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (property.propertyType != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        property.propertyType!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- Actions ---
            Column(
              children: [
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.go(
                        '/landlord/properties/edit-property/${property.id}',
                      );
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, ref);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit House'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Delete House',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (property.googleMapsUrl != null)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _launchURL(property.googleMapsUrl!),
                    icon: Icon(
                      Icons.map_outlined,
                      color: primaryColor,
                      size: 18,
                    ),
                    tooltip: 'Open in Maps',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPropertyIcon(String? type) {
    switch (type) {
      case 'Apartment Building':
        return Icons.domain;
      case 'Commercial Building':
        return Icons.business;
      case 'Standalone House':
        return Icons.home;
      case 'Studio Complex':
        return Icons.apartment;
      case 'Mixed Use':
        return Icons.store_mall_directory;
      default:
        return Icons.home_work;
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: Text(
          'Are you sure you want to delete "${property.name}"? This will also remove all units associated with it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(propertyRepositoryProvider)
                  .deleteProperty(property.id);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
