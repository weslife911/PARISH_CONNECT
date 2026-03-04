import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/theme/theme.dart';
import "package:parish_connect/repositories/auth/check_auth_repository.dart";
import 'package:parish_connect/utils/logger_util.dart';

class HeroHeader extends ConsumerWidget {
  const HeroHeader({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkAuthState = ref.watch(checkAuthRepositoryStateProvider);
    final user = checkAuthState?.user;

    logger.d(
      'HeroHeader: Building. checkAuthState success: ${checkAuthState?.success}. User is null: ${user == null}',
    );

    if (user == null) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppGradients.primary(context),
        ),
        child: const Center(
          child: Text(
            'Loading User...',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    logger.d('HeroHeader: User data found. Parish: ${user.parish}');

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
                Flexible(
                  child: Text(
                    'Welcome to ${user.parish}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.white.withOpacity(0.2),
                    ),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  ),
                  child: const Text('View Bulletin'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 96,
            height: 96,
            child: const Icon(
              Icons.temple_buddhist,
              size: 96,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
