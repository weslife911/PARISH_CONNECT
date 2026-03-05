import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/repositories/auth/check_auth_repository.dart';
import 'package:parish_connect/shell/animated_bottom_nav_bar.dart';
import 'package:parish_connect/shell/nav_item.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/authorized/activities_screen.dart';
import '../screens/authorized/home_screen.dart';
import '../screens/authorized/profile_screen.dart';
import '../screens/authorized/settings_screen.dart';
import '../widgets/app_drawer.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});
  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with TickerProviderStateMixin {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(checkAuthRepositoryStateProvider);

    if (authState == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isAdmin = authState.user?.role == "admin";

    final List<Widget> pages = [
      const HomeScreen(),
      const ActivitiesScreen(),
      if (isAdmin) const AdminDashboardScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    final items = [
      NavItem(icon: Icons.home_outlined, label: 'Home'),
      NavItem(icon: Icons.event_outlined, label: 'Activities'),
      if (isAdmin)
        NavItem(icon: Icons.dashboard_customize_outlined, label: 'Dashboard'),
      NavItem(icon: Icons.person_outline, label: 'Profile'),
      NavItem(icon: Icons.settings_outlined, label: 'Settings'),
    ];

    if (_index >= pages.length) {
      _index = pages.length - 1;
    }

    return Scaffold(
      extendBody: true,
      drawer: const AppDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: KeyedSubtree(
          key: ValueKey('${authState.user!.id}_$_index'),
          child: pages[_index],
        ),
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
