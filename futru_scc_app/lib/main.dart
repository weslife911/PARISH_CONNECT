import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // This line is crucial
import 'package:flutter_riverpod/legacy.dart';
import 'package:futru_scc_app/config/route_config.dart';
import 'package:toastification/toastification.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    const ProviderScope(child: ChurchAdminApp())
  );
}

// =============================================================================
// APP STATE (Riverpod ChangeNotifierProvider)
// =============================================================================

// Provider for AppState
final appStateProvider = ChangeNotifierProvider<AppState>((ref) => AppState()); // ChangeNotifierProvider is now defined due to the import.

class AppState extends ChangeNotifier {
  bool _initialized = false;
  bool _showOnboarding = true;
  ThemeMode _themeMode = ThemeMode.system;
  // New: Logged-in state is needed for RootNavigator logic
  bool _loggedIn = false; 

  bool get initialized => _initialized;
  bool get showOnboarding => _showOnboarding;
  ThemeMode get themeMode => _themeMode;
  bool get loggedIn => _loggedIn; // Getter for loggedIn state

  void finishInit() {
    _initialized = true;
    notifyListeners();
  }

  void completeOnboarding() {
    _showOnboarding = false;
    notifyListeners();
  }

  void setLoggedIn(bool isLoggedIn) {
    _loggedIn = isLoggedIn;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

class ChurchAdminApp extends ConsumerWidget { // Changed to ConsumerWidget
  const ChurchAdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef
    // Use ref.watch to rebuild when themeMode changes
    final appState = ref.watch(appStateProvider); 

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Church Admin',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: appState.themeMode, // Access via Riverpod state
        routerConfig: appRouter,
      ),
    );
  }
}