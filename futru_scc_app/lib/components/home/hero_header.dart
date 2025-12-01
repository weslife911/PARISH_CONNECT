import 'package:flutter/material.dart';
import 'package:futru_scc_app/theme/theme.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppGradients.primary(context),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('St. Mary’s Parish',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('“One body, many parts.”',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.white.withValues(alpha: 0.2)),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  ),
                  child: const Text('View Bulletin'),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.temple_buddhist, size: 96, color: Colors.white),
        ],
      ),
    );
  }
}