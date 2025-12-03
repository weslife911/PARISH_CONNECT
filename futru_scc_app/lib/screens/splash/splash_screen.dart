import 'package:flutter/material.dart';
import "package:futru_scc_app/theme/theme.dart";
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart' as rive;

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
                  child: const rive.RiveAnimation.asset(
                    "assets/rive/vehicles.riv",
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