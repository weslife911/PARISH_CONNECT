import 'package:parish_connect/navigator/root_navigator.dart';
import 'package:parish_connect/screens/admin/admin_dashboard.dart';
import 'package:parish_connect/screens/auth/auth_screen.dart';
import 'package:parish_connect/screens/authorized/activities_screen.dart';
import 'package:parish_connect/screens/authorized/home_screen.dart';
import 'package:parish_connect/screens/authorized/profile_screen.dart';
import 'package:parish_connect/screens/authorized/section_screen.dart';
import 'package:parish_connect/screens/authorized/settings_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: "/navigator",
  routes: [

    //NAVIGATOR
    GoRoute(
      path: "/navigator",
      name: "navigator",
      builder: (context, state) => RootNavigator(),
    ),

    // AUTH
    GoRoute(
      path: "/auth",
      name: "auth",
      builder: (context, state) => AuthScreen(),
    ),

    // AUTHORIZED
    GoRoute(
      path: "/profile",
      name: "profile",
      builder: (context, state) => ProfileScreen(),
    ),

    GoRoute(
      path: "/settings",
      name: "settings",
      builder: (context, state) => SettingsScreen(),
    ),

    GoRoute(
      path: "/home",
      name: "home",
      builder: (context, state) => HomeScreen(),
    ),

    GoRoute(
      path: "/activities",
      name: "activities",
      builder: (context, state) => ActivitiesScreen(),
    ),

    GoRoute(
      path: "/section",
      name: "section",
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;

        final title = args?['title'] as String? ?? 'SCC';

        final initialIndex = args?['initialTabIndex'] as int? ?? 0;

        return SectionScreen(
          title: title,
          initialTabIndex: initialIndex,
        );
      },
    ),

    // ADMIN
    GoRoute(
      path: "/admin",
      name: "admin",
      builder: (context, state) => AdminDashboardScreen(),
    ),
  ]
);
