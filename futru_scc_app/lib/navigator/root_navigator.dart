import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/models/auth/check_auth_response_model.dart';
import 'package:futru_scc_app/repositories/auth/check_auth_repository.dart';
import 'package:futru_scc_app/screens/splash/splash_screen.dart';
import 'package:toastification/toastification.dart';
import '../main.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../shell/main_shell.dart';
import 'package:futru_scc_app/widgets/helpers.dart';

// =============================================================================
// ROOT NAVIGATOR (Splash -> Onboarding -> Auth -> Main)
// =============================================================================

class RootNavigator extends ConsumerStatefulWidget {
  const RootNavigator({super.key});

  @override
  ConsumerState<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends ConsumerState<RootNavigator>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });
  }

  void checkAuth() async {
    final CheckAuthResponseModel checkAuthResponseModel = await ref.read(checkAuthRepositoryProvider).checkAuth();
    
    if(!mounted) {
      return;
    } 

    final appStateNotifier = ref.read(appStateProvider.notifier);

    showToast(context, checkAuthResponseModel.message!, type: checkAuthResponseModel.success == true ? ToastificationType.success : ToastificationType.error);
    
    if(checkAuthResponseModel.success == true && checkAuthResponseModel.user != null) {
      // FIX: Correctly set the state using .state = value (replaces .update)
      ref.read(checkAuthRepositoryStateProvider.notifier).update((state) => checkAuthResponseModel);
      
      appStateNotifier.setLoggedIn(true);

    } else {
      // Also clear the state if auth fails (good practice)
      ref.read(checkAuthRepositoryStateProvider.notifier).state = null; 
      appStateNotifier.setLoggedIn(false);
    }
    appStateNotifier.finishInit();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    
    Widget child;
    if (!appState.initialized) {
      child = const SplashScreen(); // Will be shown until finishInit() is called.
    } else if (appState.showOnboarding) {
      child = const OnboardingScreen();
    } else if (!appState.loggedIn) { // Use the loggedIn getter from AppState
      child = const AuthScreen();
    } else {
      child = const MainShell();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
              .animate(anim),
          child: child,
        ),
      ),
      child: child,
    );
  }
}