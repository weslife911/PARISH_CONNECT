import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import '../../main.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/helpers.dart'; // For showToast
import 'package:futru_scc_app/repositories/storage/local_storage_repository.dart';
import 'package:futru_scc_app/repositories/auth/check_auth_repository.dart';

// =============================================================================
// SETTINGS
// =============================================================================

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    ThemeMode mode = app.themeMode;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const AppDrawer(),
      body: ListView(
        // FIX: Added bottom padding to raise content above the custom bottom navigation bar.
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          Card(
            child: Column(children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle between light and dark themes'),
                value: mode == ThemeMode.dark,
                onChanged: (v) => app.setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Notifications'),
                subtitle: const Text('Manage preferences'),
                onTap: () => showToast(context, 'Notifications preferences not connected'),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language'),
                subtitle: const Text('English'),
                onTap: () {},
              ),
            ]),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout'),
                onTap: () async {
                      // 1. Clear the token from storage
                      await LocalStorageRepository().removeJWTAuthToken();
                      
                      // 2. Reset Riverpod Auth State
                      ref.read(checkAuthRepositoryStateProvider.notifier).state = null;
                      
                      // 3. Update App State (triggers RootNavigator to switch to AuthScreen)
                      ref.read(appStateProvider.notifier).setLoggedIn(false);

                      // 4. Navigate to Auth Screen (using goRouter)
                      if(context.mounted) {
                        context.goNamed("auth");
                      }
                    },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete/Disable Account'),
                onTap: () => showToast(context, 'Account action requires backend', type: ToastificationType.warning),
              ),
            ]),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}