// lib/components/steps/parish/step_parish_general_report.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/forms/parish_form.dart';
import 'package:parish_connect/widgets/builds/build_list_input.dart'; // Assuming DynamicListInputField exists

class StepParishGeneralReport extends ConsumerWidget {
  final ParishFormState parent;

  const StepParishGeneralReport({
    super.key,
    required this.parent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onListChanged() {
      parent.setState(() {});
    }

    // FIX: Wrap everything in a SingleChildScrollView to prevent bottom overflow
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '4. General Report Sections',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          DynamicListInputField(
            list: parent.problemsAndSolutions,
            labelText: 'Problems Encountered & Proposed Solutions *',
            icon: Icons.error_outline,
            isRequired: true,
            onListChanged: onListChanged,
          ),

          const SizedBox(height: 16), // Added spacing between fields

          DynamicListInputField(
            list: parent.issuesForCouncil,
            labelText: 'Issues for Parish Council Discussion *',
            icon: Icons.gavel_outlined,
            isRequired: true,
            onListChanged: onListChanged,
          ),

          const SizedBox(height: 16),

          DynamicListInputField(
            list: parent.futurePlans,
            labelText: 'Plans for the Next Year (Including Budget/Income) *',
            icon: Icons.event_note_outlined,
            isRequired: true,
            onListChanged: onListChanged,
          ),

          const SizedBox(
            height: 80,
          ), // Extra space at bottom to account for the "Submit" button
        ],
      ),
    );
  }
}
