import 'package:flutter/material.dart';
import 'package:parish_connect/components/state/main_app_state.dart';
import 'package:parish_connect/config/route_config.dart';
import 'package:parish_connect/theme/theme.dart';
import 'package:toastification/toastification.dart';

Widget mainBuildUI(BuildContext context, MainAppState appState) {
  if (!appState.initialized) {
    return MaterialApp(
      key: const ValueKey('splash'),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.church, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  return ToastificationWrapper(
    key: const ValueKey('app'),
    child: MaterialApp.router(
      title: 'Parish Connect',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: appState.themeMode,
      routerConfig: appRouter, //
    ),
  );
}
