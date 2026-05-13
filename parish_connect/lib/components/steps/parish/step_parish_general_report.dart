import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/forms/parish_form.dart';
import 'package:parish_connect/widgets/builds/build_list_input.dart';

class StepParishGeneralReport extends ConsumerWidget {
  final ParishFormState parent;
  final bool isLoading;
  final VoidCallback onSaveForm;
  final VoidCallback onListChanged;

  const StepParishGeneralReport({
    super.key,
    required this.parent,
    required this.isLoading,
    required this.onSaveForm,
    required this.onListChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. General Report Sections',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        DynamicListInputField(
          list: parent.problemsAndSolutions,
          labelText: 'Problems & Proposed Solutions *',
          icon: Icons.error_outline,
          isRequired: true,
          onListChanged: onListChanged,
        ),
        const SizedBox(height: 16),
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
          labelText: 'Plans for Next Year *',
          icon: Icons.event_note_outlined,
          isRequired: true,
          onListChanged: onListChanged,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : FilledButton.icon(
                  onPressed: onSaveForm,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'SUBMIT PARISH REPORT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
      ],
    );
  }
}
