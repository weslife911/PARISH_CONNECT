import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parish_connect/repositories/auth/check_auth_repository.dart';

class MainAppState extends ChangeNotifier {
  final Ref _ref;
  bool _initialized = false;
  bool _showOnboarding = true;
  ThemeMode _themeMode = ThemeMode.system;
  bool _loggedIn = false;

  MainAppState(this._ref) {
    _init();
  }

  Future<void> _init() async {
    await Future.wait([
      _loadOnboardingStatus(),
      _checkInitialAuth(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    _initialized = true;
    notifyListeners(); //
  }

  bool get initialized => _initialized;
  bool get showOnboarding => _showOnboarding;
  ThemeMode get themeMode => _themeMode;
  bool get loggedIn => _loggedIn;

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _showOnboarding = !(prefs.getBool(onboardingKey) ?? false); //
  }

  Future<void> _checkInitialAuth() async {
    final authResult = await _ref.read(checkAuthRepositoryProvider).checkAuth();
    _loggedIn = authResult.success; //
  }

  void finishInit() {
    _initialized = true;
    notifyListeners(); //
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(onboardingKey, true);
    _showOnboarding = false;
    notifyListeners(); //
  }

  void setLoggedIn(bool isLoggedIn) {
    _loggedIn = isLoggedIn;
    notifyListeners(); //
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners(); //
  }
}
