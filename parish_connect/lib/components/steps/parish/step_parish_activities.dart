// lib/components/steps/parish/step_parish_activities.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/forms/parish_form.dart';
import 'package:parish_connect/widgets/builds/build_list_input.dart'; // Assuming DynamicListInputField exists

class StepParishActivities extends ConsumerWidget {
  final ParishFormState parent;

  const StepParishActivities({
    super.key,
    required this.parent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('3. Activities Carried Out', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        // Single list input for all activities
        DynamicListInputField(
          list: parent.activities,
          labelText: 'Activities Carried Out (Past Three Months) *',
          icon: Icons.local_activity_outlined,
          isRequired: true,
          // Use a setState wrapper to ensure the parent list is updated and triggers a UI refresh
          onListChanged: () {
            parent.setState(() {});
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
