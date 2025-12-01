import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../shell/main_shell.dart';
import '../theme/theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' as rive;

// =============================================================================
// ROOT NAVIGATOR (Splash -> Onboarding -> Auth -> Main)
// =============================================================================

class RootNavigator extends StatefulWidget {
  const RootNavigator({super.key});

  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Simulate initialization delay (splash)
    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) appState.finishInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        Widget child;
        if (!appState.initialized) {
          child = const SplashScreen();
        } else if (appState.showOnboarding) {
          child = const OnboardingScreen();
        } else if (!appState.loggedIn) {
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
      },
    );
  }
}

// =============================================================================
// SPLASH
// =============================================================================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppGradients.primary(context)),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.surface.withValues(alpha: 0.0),
                    cs.surface.withValues(alpha: 0.15),
                    cs.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primary(context),
                    boxShadow: AppShadows.soft(context),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: const rive.RiveAnimation.network(
                    'https://cdn.rive.app/animations/vehicles.riv',
                    fit: BoxFit.cover,
                  ),
                ).animate().scale(duration: 450.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 18),
                Text('Parish Connect',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w800,
                        )),
                const SizedBox(height: 8),
                Text('Administer • Unite • Serve',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        )),
                const SizedBox(height: 24),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}