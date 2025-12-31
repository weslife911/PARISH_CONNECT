import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/theme/theme.dart';
import "package:parish_connect/repositories/auth/check_auth_repository.dart";
import 'package:parish_connect/utils/logger_util.dart';

class HeroHeader extends ConsumerWidget {
  const HeroHeader({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the entire CheckAuthResponseModel, not just .user, for changes
    final checkAuthState = ref.watch(checkAuthRepositoryStateProvider);
    final user = checkAuthState?.user;

    // Replaced print with logger
    logger.d('HeroHeader: Building. checkAuthState success: ${checkAuthState?.success}. User is null: ${user == null}');

    // FIX: Add explicit null check to prevent crash (the cause of 'state still shows null in hero_header')
    if (user == null) {
      // Return a loading or placeholder widget if user data isn't available yet
      return Container(
        height: 180,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppGradients.primary(context),
        ),
        child: const Center(child: Text('Loading User...', style: TextStyle(color: Colors.white, fontSize: 18))),
      );
    }

    // Safely use user's data now that we know it's not null
    // Replaced print with logger
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
          Expanded( // Takes up all remaining space in the Row
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // FIX: Ensure the text widget uses the full horizontal space available
                // in the Expanded parent, allowing it to wrap.
                Flexible(
                  child: Text('Welcome to ${user.parish}',
                      maxLines: 3, // Allow wrapping up to 3 lines
                      // Ensure text is clipped if it somehow still overflows
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18.0, // Reduced font size to 18.0
                          )),
                ),
                const SizedBox(height: 8),
                // Secondary text is also wrapped in Flexible to ensure vertical fit
                // Flexible(
                //   child: Text('“One body, many parts.”',
                //       style: Theme.of(context)
                //           .textTheme
                //           .titleMedium
                //           ?.copyWith(color: Colors.white.withOpacity(0.9))),
                // ),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.white.withOpacity(0.2)),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                  ),
                  child: const Text('View Bulletin'),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Set a constrained size for the Icon to ensure it doesn't take up
          // too much space, giving more room to the Expanded Column.
          SizedBox(
            width: 96,
            height: 96,
            child: const Icon(Icons.temple_buddhist, size: 96, color: Colors.white)
          ),
        ],
      ),
    );
  }
}
