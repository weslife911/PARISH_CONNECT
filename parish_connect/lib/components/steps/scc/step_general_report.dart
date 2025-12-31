// lib/components/scc_form/steps/step_general_report.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/widgets/builds/build_list_input.dart';

class StepGeneralReport extends ConsumerWidget {
  final List<String> problemsList;
  final List<String> solutionsList;
  final List<String> issuesList;
  final List<String> nextMonthPlansList;
  final VoidCallback onSaveForm;
  final VoidCallback onListChanged;

  const StepGeneralReport({
    super.key,
    required this.problemsList,
    required this.solutionsList,
    required this.issuesList,
    required this.nextMonthPlansList,
    required this.onSaveForm,
    required this.onListChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DynamicListInputField(
          list: problemsList,
          labelText: 'Problems Encountered',
          icon: Icons.error_outline,
          isRequired: true,
          onListChanged: onListChanged,
        ),
        DynamicListInputField(
          list: solutionsList,
          labelText: 'Proposed Solutions',
          icon: Icons.lightbulb_outline,
          onListChanged: onListChanged,
        ),
        DynamicListInputField(
          list: issuesList,
          labelText: 'Issues to be discussed in the Council',
          icon: Icons.gavel_outlined,
          onListChanged: onListChanged,
        ),

        DynamicListInputField(
          list: nextMonthPlansList,
          labelText: 'Plan for the next Month',
          icon: Icons.event_note_outlined,
          isRequired: true,
          onListChanged: onListChanged,
        ),
        const SizedBox(height: 24),

        // Submission Button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onSaveForm,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('SUBMIT FINAL REPORT', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
