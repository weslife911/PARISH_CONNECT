import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../main.dart';
import '../../theme/theme.dart';

// =============================================================================
// ONBOARDING
// =============================================================================

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  void _next() async {
    if (_index < 2) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic);
    } else {
      // Mark onboarding as completed and save to SharedPreferences
      await ref.read(appStateProvider.notifier).completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  _OnboardPage(
                    title: 'Welcome to Parish Connect',
                    subtitle:
                        'A beautiful, streamlined way to manage SCCs, Parishes, Missions and Deaneries.',
                    emoji: '⛪',
                  ),
                  _OnboardPage(
                    title: 'Powerful Admin Tools',
                    subtitle:
                        'Analytics, quick actions, and user management — all at your fingertips.',
                    emoji: '🛠️',
                  ),
                  _OnboardPage(
                    title: 'Stay in the Loop',
                    subtitle:
                        'Activities, documents, and updates — always organized, always accessible.',
                    emoji: '🗂️',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: cs.primary,
                      dotColor: cs.onSurfaceVariant.withValues(alpha: 0.3),
                      expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _next,
                    child: Text(_index < 2 ? 'Next' : 'Get Started'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage(
      {required this.title, required this.subtitle, required this.emoji});
  final String title;
  final String subtitle;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primary(context),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 88)),
          ),
          const SizedBox(height: 24),
          Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}