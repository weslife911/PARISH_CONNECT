import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'theme/theme.dart';
import 'navigator/root_navigator.dart';

void main() {
  runApp(const ChurchAdminApp());
}

// =============================================================================
// APP STATE (no Provider; plain Dart ChangeNotifier + global instance)
// =============================================================================

final AppState appState = AppState();

class AppState extends ChangeNotifier {
  bool _initialized = false;
  bool _showOnboarding = true;
  bool _loggedIn = false;
  bool _isAdmin = false;
  ThemeMode _themeMode = ThemeMode.system;

  bool get initialized => _initialized;
  bool get showOnboarding => _showOnboarding;
  bool get loggedIn => _loggedIn;
  bool get isAdmin => _isAdmin;
  ThemeMode get themeMode => _themeMode;

  void finishInit() {
    _initialized = true;
    notifyListeners();
  }

  void completeOnboarding() {
    _showOnboarding = false;
    notifyListeners();
  }

  void login({required String email}) {
    _loggedIn = true;
    _isAdmin = email.toLowerCase().contains('admin');
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    _isAdmin = false;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

class ChurchAdminApp extends StatelessWidget {
  const ChurchAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return ToastificationWrapper(
          child: MaterialApp(
            title: 'Church Admin',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: appState.themeMode,
            home: const RootNavigator(),
          ),
        );
      },
    );
  }
}