import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/repositories/storage/local_storage_repository.dart';
import 'package:go_router/go_router.dart';
// import 'package:rive/rive.dart' as rive; // REMOVED RIVE IMPORT
import '../main.dart';
import '../screens/authorized/section_screen.dart';
import 'helpers.dart'; // For AnimatedRoute
import 'package:futru_scc_app/repositories/auth/check_auth_repository.dart';

// =============================================================================
// APP DRAWER
// =============================================================================

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final appState = ref.watch(appStateProvider);
    final isAdmin = ref.read(checkAuthRepositoryStateProvider)?.user?.role == "admin";
    
    // Determine the color of the church icon
    final iconColor = cs.primary; // Often the primary color works well for contrast

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // START OF STANDARD DRAWER HEADER
            DrawerHeader(
              decoration: BoxDecoration(
                // Removed all explicit colors to use the default Drawer background
                color: Theme.of(context).drawerTheme.backgroundColor, 
                // Removed borderRadius as it's not standard for DrawerHeader
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.church, 
                    size: 48, 
                    color: iconColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Parish Connect',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800), // Default text color will be used
                  ),
                  Text(
                    'Church Administration',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            // END OF STANDARD DRAWER HEADER
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
                  if(isAdmin) ListTile(
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
                    onTap: () async {
                      await LocalStorageRepository().removeJWTAuthToken();
                      context.goNamed("auth");
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