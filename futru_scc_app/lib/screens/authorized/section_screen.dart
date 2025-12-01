import 'package:flutter/material.dart';
import 'package:futru_scc_app/components/section/add_new_form.dart';
import 'package:futru_scc_app/components/section/list_tab.dart';
import 'package:futru_scc_app/components/section/overview_tab.dart';
import '../../widgets/app_drawer.dart';

// =============================================================================
// SECTION SCREEN (SCC / Parish / Mission Station / Deanery)
// =============================================================================

class SectionScreen extends StatefulWidget {
  const SectionScreen({super.key, required this.title});
  final String title;
  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
              ),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelColor: cs.onSurfaceVariant,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'List'),
                  Tab(text: 'Add New'),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: TabBarView(
        controller: _tab,
        children: [
          OverviewTab(title: widget.title),
          const ListTab(),
          AddNewForm(section: widget.title),
        ],
      ),
    );
  }
}







