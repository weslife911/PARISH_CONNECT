import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parish_connect/config/route_config.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final appStateProvider = ChangeNotifierProvider<AppState>((ref) => AppState());

class AppState extends ChangeNotifier {
  bool _initialized = false;
  bool _showOnboarding = true;
  ThemeMode _themeMode = ThemeMode.system;
  bool _loggedIn = false;

  static const String _onboardingKey = 'has_seen_onboarding';

  bool get initialized => _initialized;
  bool get showOnboarding => _showOnboarding;
  ThemeMode get themeMode => _themeMode;
  bool get loggedIn => _loggedIn;

  Future<void> loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _showOnboarding = !(prefs.getBool(_onboardingKey) ?? false);
    notifyListeners();
  }

  void finishInit() {
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Parish Connect',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: appState.themeMode,
        routerConfig: appRouter,
      ),
    );
  }
}
