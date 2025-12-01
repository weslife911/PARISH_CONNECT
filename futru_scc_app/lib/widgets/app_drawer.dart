import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' as rive;
import '../main.dart';
import '../screens/authorized/section_screen.dart';
import 'helpers.dart'; // For AnimatedRoute

// =============================================================================
// APP DRAWER (Animated with Rive header)
// =============================================================================

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: rive.RiveAnimation.asset(
                        'assets/animations/vehicles.riv',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: cs.primaryContainer,
                          child: Icon(Icons.church, color: cs.onPrimaryContainer),
                        ),
                        const SizedBox(width: 10),
                        Text('Parish Connect',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: Icon(Icons.home_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Home'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.event_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Activities'),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.dashboard_customize_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Admin Dashboard'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.groups_2_outlined, color: cs.onSurfaceVariant),
                    title: const Text('SCC'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(AnimatedRoute(const SectionScreen(title: 'SCC')));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.church_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Parish'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(AnimatedRoute(const SectionScreen(title: 'Parish')));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.location_city_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Mission Station'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(AnimatedRoute(const SectionScreen(title: 'Mission Station')));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_outlined, color: cs.onSurfaceVariant),
                    title: const Text('Deanery'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(AnimatedRoute(const SectionScreen(title: 'Deanery')));
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: appState.themeMode == ThemeMode.dark,
                    onChanged: (v) => appState.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    onTap: () {
                      appState.logout();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ).animate().fadeIn(duration: 250.ms),
            ),
          ],
        ),
      ),
    );
  }
}