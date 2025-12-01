import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:futru_scc_app/components/home/activity_tile.dart';
import '../../widgets/app_drawer.dart';

// =============================================================================
// ACTIVITIES (placeholder list with pull-to-refresh)
// =============================================================================

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});
  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<String> items = List.generate(10, (i) => 'Activity ${i + 1}');
  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => items = List.from(items.reversed));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, i) => ActivityTile(
            title: items[i],
            subtitle: 'Tap to view details',
            onTap: () {},
          ).animate(delay: (i * 40).ms).fadeIn().move(begin: const Offset(0, 8)),
        ),
      ),
    );
  }
}

