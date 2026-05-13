import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/forms/parish_form.dart';
import 'package:parish_connect/widgets/builds/build_list_input.dart';

class StepParishActivities extends ConsumerWidget {
  final ParishFormState parent;
  final VoidCallback onListChanged;

  const StepParishActivities({
    super.key,
    required this.parent,
    required this.onListChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3. Activities Carried Out',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        DynamicListInputField(
          list: parent.activities,
          labelText: 'Activities (Past Three Months) *',
          icon: Icons.local_activity_outlined,
          isRequired: true,
          onListChanged: onListChanged,
        ),
      ],
    );
  }
}
