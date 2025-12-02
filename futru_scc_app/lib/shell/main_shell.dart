import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/repositories/auth/check_auth_repository.dart';
import 'package:futru_scc_app/shell/animated_bottom_nav_bar.dart';
import 'package:futru_scc_app/shell/nav_item.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/authorized/activities_screen.dart';
import '../screens/authorized/home_screen.dart';
import '../screens/authorized/profile_screen.dart';
import '../screens/authorized/settings_screen.dart';
import '../widgets/app_drawer.dart';

// =============================================================================
// MAIN SHELL + ANIMATED BOTTOM NAV
// =============================================================================

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});
  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> with TickerProviderStateMixin {
  int _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // FIX: Use null-aware operator (?.) to safely access the role.
    // Default to false if the user object or repository state is null.
    final isAdmin = ref.read(checkAuthRepositoryStateProvider)?.user?.role == "admin";
    
    _pages = [
      const HomeScreen(),
      const ActivitiesScreen(),
      if (isAdmin) const AdminDashboardScreen(), // Use isAdmin flag
      const ProfileScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(checkAuthRepositoryStateProvider)?.user?.role == "admin";
    
    final items = [
      NavItem(icon: Icons.home_outlined, label: 'Home'),
      NavItem(icon: Icons.event_outlined, label: 'Activities'),
      if (isAdmin) NavItem(icon: Icons.dashboard_customize_outlined, label: 'Dashboard'), // Use isAdmin flag
      NavItem(icon: Icons.person_outline, label: 'Profile'),
      NavItem(icon: Icons.settings_outlined, label: 'Settings'),
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



