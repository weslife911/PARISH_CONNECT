// lib/components/scc_form/steps/step_activities_part2.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/widgets/builds/build_list_input.dart';

class StepActivitiesPart2 extends ConsumerWidget {
  final List<String> youthApostolateList;
  final List<String> catecheticalList;
  final List<String> healthCareList;
  final VoidCallback onListChanged;

  const StepActivitiesPart2({
    super.key,
    required this.youthApostolateList,
    required this.catecheticalList,
    required this.healthCareList,
    required this.onListChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DynamicListInputField(
          list: youthApostolateList,
          labelText: 'Activities: Youth Apostolate',
          icon: Icons.directions_run_outlined,
          onListChanged: onListChanged,
        ),
        DynamicListInputField(
          list: catecheticalList,
          labelText: 'Activities: Catechetical',
          icon: Icons.school_outlined,
          onListChanged: onListChanged,
        ),
        DynamicListInputField(
          list: healthCareList,
          labelText: 'Activities: Health Care',
          icon: Icons.medical_services_outlined,
          onListChanged: onListChanged,
        ),
      ],
    );
  }
}
