import 'package:flutter/material.dart';
import '../main.dart';
import '../theme/theme.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/authorized/activities_screen.dart';
import '../screens/authorized/home_screen.dart';
import '../screens/authorized/profile_screen.dart';
import '../screens/authorized/settings_screen.dart';
import '../widgets/app_drawer.dart';

// =============================================================================
// MAIN SHELL + ANIMATED BOTTOM NAV
// =============================================================================

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final isAdmin = appState.isAdmin;
    _pages = [
      const HomeScreen(),
      const ActivitiesScreen(),
      if (isAdmin) const AdminDashboardScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = appState.isAdmin;
    final items = [
      _NavItem(icon: Icons.home_outlined, label: 'Home'),
      _NavItem(icon: Icons.event_outlined, label: 'Activities'),
      if (isAdmin) _NavItem(icon: Icons.dashboard_customize_outlined, label: 'Dashboard'),
      _NavItem(icon: Icons.person_outline, label: 'Profile'),
      _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
    ];

    // keep index within bounds if admin toggled state changed
    if (_index >= items.length) _index = items.length - 1;

    return Scaffold(
      extendBody: true,
      drawer: const AppDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _pages[_index],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: AnimatedBottomNavBar(
          currentIndex: _index,
          items: items,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}

class AnimatedBottomNavBar extends StatelessWidget {
  const AnimatedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.soft(context),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++)
            _AnimatedNavItem(
              index: i,
              selected: i == currentIndex,
              item: items[i],
              onTap: () => onTap(i),
            ),
        ],
      ),
    );
  }
}

class _AnimatedNavItem extends StatelessWidget {
  const _AnimatedNavItem({
    required this.index,
    required this.selected,
    required this.item,
    required this.onTap,
  });
  final int index;
  final bool selected;
  final _NavItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? cs.primaryContainer.withValues(alpha: 0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon,
                  color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: SizedBox(width: selected ? 8 : 0),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: selected ? 1 : 0,
                child: Text(
                  selected ? item.label : '',
                  overflow: TextOverflow.fade,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}