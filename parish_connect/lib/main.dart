import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:parish_connect/components/builds/main/main_build_ui.dart';
import 'package:parish_connect/components/state/main_app_state.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final appStateProvider = ChangeNotifierProvider<MainAppState>(
  (ref) => MainAppState(ref),
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: mainBuildUI(context, appState),
    );
  }
}
