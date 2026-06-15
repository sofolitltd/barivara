import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:barivara/shared/widgets/responsive_layout.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return SelectionArea(
      child: Scaffold(
        body: Row(
          children: [
            if (isDesktop)
              _buildNavigationRail(context, isDark),
            Expanded(child: navigationShell),
          ],
        ),
        bottomNavigationBar: !isDesktop ? _buildBottomNavBar(context, isDark) : null,
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context, bool isDark) {
    final activeColor = const Color(0xFF6366F1);
    
    return NavigationRail(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _onTap,
      labelType: NavigationRailLabelType.all,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      indicatorColor: activeColor.withValues(alpha: 0.1),
      selectedIconTheme: IconThemeData(color: activeColor),
      unselectedIconTheme: IconThemeData(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
      selectedLabelTextStyle: TextStyle(color: activeColor, fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelTextStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), fontSize: 12),
      leading: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.home_work, color: Color(0xFF6366F1), size: 28),
          ),
          const SizedBox(height: 40),
        ],
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.domain_outlined),
          selectedIcon: Icon(Icons.domain),
          label: Text('Properties'),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                label: 'Dashboard',
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => _onTap(0),
                isDark: isDark,
              ),
              _NavBarItem(
                icon: Icons.domain_outlined,
                activeIcon: Icons.domain,
                label: 'Properties',
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => _onTap(1),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF6366F1);
    final inactiveColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : inactiveColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
