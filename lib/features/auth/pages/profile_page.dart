import 'package:barivara/features/auth/models/app_user.dart';
import 'package:barivara/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barivara/shared/providers/theme_provider.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(currentUserProvider);

    return SelectionArea(
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: MaxWidthContainer(
            child: AppBar(
              title: const Text(
                'Account Profile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        body: MaxWidthContainer(
          child: userAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (user) {
              if (user == null) {
                return const Center(child: Text('Please login'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // --- USER HEADER ---
                    _buildUserHeader(user, isDark),
                    const SizedBox(height: 32),

                    // --- ACCOUNT SETTINGS ---
                    _buildSectionHeader('Account Settings', isDark),
                    const SizedBox(height: 12),
                    _buildProfileItem(
                      icon: Icons.person_outline,
                      title: 'Personal Information',
                      subtitle: 'Name: ${user.name}\nPhone: ${user.phone}',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: Icons.email_outlined,
                      title: 'Email Address',
                      subtitle: user.email,
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      subtitle: 'Manage your alert preferences',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: Icons.security_outlined,
                      title: 'Security',
                      subtitle: 'Change password and 2FA',
                      isDark: isDark,
                      onTap: () {},
                    ),

                    const SizedBox(height: 32),

                    // --- APP PREFERENCES ---
                    _buildSectionHeader('Preferences', isDark),
                    const SizedBox(height: 12),
                    _buildThemeSwitch(currentThemeMode, themeNotifier, isDark),
                    _buildProfileItem(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: 'English (US)',
                      isDark: isDark,
                      onTap: () {},
                    ),

                    const SizedBox(height: 32),

                    // --- ACTIONS ---
                    if (user.role == 'landlord' || user.role == 'admin') ...[
                      _buildSectionHeader('Quick Links', isDark),
                      const SizedBox(height: 12),
                      if (user.role == 'landlord')
                        _buildProfileItem(
                          icon: Icons.home_work_outlined,
                          title: 'Home Management',
                          subtitle: 'Manage your properties and units',
                          isDark: isDark,
                          color: const Color(0xFF6366F1),
                          onTap: () => context.go('/landlord/properties'),
                        ),
                      if (user.role == 'admin')
                        _buildProfileItem(
                          icon: Icons.admin_panel_settings_outlined,
                          title: 'Admin Dashboard',
                          subtitle: 'Platform administrative controls',
                          isDark: isDark,
                          color: Colors.orange,
                          onTap: () => context.go('/admin'),
                        ),
                    ],

                    const SizedBox(height: 48),

                    // --- LOGOUT ---
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // TODO: Implement logout
                        },
                        icon: const Icon(Icons.logout, size: 20),
                        label: const Text('Logout'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Version 1.0.0 (Build 240506)',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(AppUser user, bool isDark) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : null,
                child: user.photoUrl == null
                    ? Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    width: 3,
                  ),
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.role.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (color ?? const Color(0xFF6366F1)).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color ?? const Color(0xFF6366F1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(
    ThemeMode mode,
    ThemeModeNotifier notifier,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Switch between light and dark themes',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: mode == ThemeMode.dark,
            onChanged: (v) => notifier.toggleTheme(),
            activeThumbColor: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }
}
