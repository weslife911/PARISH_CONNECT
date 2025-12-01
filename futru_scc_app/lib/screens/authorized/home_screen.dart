import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:futru_scc_app/components/home/hero_header.dart';
import '../../main.dart';
import 'section_screen.dart';
import '../admin/admin_dashboard.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/helpers.dart'; // For _AnimatedRoute
import "package:futru_scc_app/components/home/activity_tile.dart";
import "package:futru_scc_app/components/home/quick_card.dart";

// =============================================================================
// HOME
// =============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = appState.isAdmin;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Parish Connect'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.wb_sunny_outlined, color: Colors.amber),
            onPressed: () {
              appState.setThemeMode(appState.themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HeroHeader().animate().fadeIn(duration: 400.ms).move(begin: const Offset(0, 12)),
          const SizedBox(height: 16),
          Text('Quick Access', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 120,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            children: [
              QuickCard(
                icon: Icons.groups_2_outlined,
                title: 'SCC',
                onTap: () => _openSection(context, 'SCC'),
              ).animate().fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
              QuickCard(
                icon: Icons.church_outlined,
                title: 'Parish',
                onTap: () => _openSection(context, 'Parish'),
              ).animate(delay: 60.ms).fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
              QuickCard(
                icon: Icons.location_city_outlined,
                title: 'Mission Station',
                onTap: () => _openSection(context, 'Mission Station'),
              ).animate(delay: 120.ms).fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
              QuickCard(
                icon: Icons.account_balance_outlined,
                title: 'Deanery',
                onTap: () => _openSection(context, 'Deanery'),
              ).animate(delay: 180.ms).fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
              if (isAdmin)
                QuickCard(
                  icon: Icons.dashboard_customize_outlined,
                  title: 'Admin',
                  onTap: () => Navigator.of(context).push(
                      AnimatedRoute(const AdminDashboardScreen())),
                ).animate(delay: 240.ms).fadeIn(duration: 300.ms).move(begin: const Offset(0, 10)),
            ],
          ),
          const SizedBox(height: 20),
          Text('Upcoming Activities', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(
            4,
            (i) => ActivityTile(
              title: 'Community Service Day',
              subtitle: 'Saturday 10:00 AM · Parish Grounds',
              onTap: () {},
            ).animate(delay: (i * 80).ms).fadeIn(duration: 350.ms).move(begin: const Offset(0, 10)),
          )
        ],
      ),
    );
  }

  void _openSection(BuildContext context, String title) {
    Navigator.of(context).push(AnimatedRoute(SectionScreen(title: title)));
  }
}

