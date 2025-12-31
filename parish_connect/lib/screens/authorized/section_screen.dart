// section_screen.dart

import 'package:flutter/material.dart';
import 'package:parish_connect/widgets/builds/build_add_new_form.dart';
import 'package:parish_connect/widgets/builds/build_overview_tab.dart';
// NEW IMPORT:
import 'package:parish_connect/widgets/builds/build_list_tab.dart';

import '../../widgets/app_drawer.dart';

// =============================================================================
// SECTION SCREEN (SCC / Parish / Mission Station / Deanery)
// =============================================================================

class SectionScreen extends StatefulWidget {
  // MODIFIED: Added optional initialTabIndex, defaulting to 0 (Overview)
  const SectionScreen({
    super.key,
    required this.title,
    this.initialTabIndex = 0,
  });

  final String title;
  final int initialTabIndex; // New field to store the initial tab index

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen>
    with SingleTickerProviderStateMixin {
  // MODIFIED: Changed initialization to happen in initState
  late final TabController _tab;

  // DUMMY DATA: This data is for the entire app, ListTab will now filter it.
  final List<String> sections = const [
    'St. Anthony SCC',
    'St. Jude SCC',
    'Holy Family Parish',
    'St. Peter Mission Station',
    'St. Michael Deanery',
    'St. Leo SCC',
    'St. Mark Parish',
    'Our Lady of Fatima SCC',
    'Divine Mercy SCC',
    'St. Paul Parish',
  ];

  @override
  void initState() {
    super.initState();
    // MODIFIED: Initialize TabController using the initialTabIndex from the widget
    _tab = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex, // Use the new parameter
    );
  }

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
                border: Border.all(color: cs.outline.withOpacity(0.15)),
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
          buildOverviewTab(widget.title),
          buildListTab(widget.title, sections),
          buildAddNewForm(widget.title)
        ],
      ),
    );
  }
}
