// lib/components/scc_form/steps/step_activities_part1.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/widgets/builds/_build_list_input.dart';

class StepActivitiesPart1 extends ConsumerWidget {
  final List<String> biblicalApostolateList;
  final List<String> liturgyList;
  final List<String> financeList;
  final List<String> familyLifeList;
  final List<String> justiceAndPeaceList;
  final VoidCallback onListChanged;

  const StepActivitiesPart1({
    super.key,
    required this.biblicalApostolateList,
    required this.liturgyList,
    required this.financeList,
    required this.familyLifeList,
    required this.justiceAndPeaceList,
    required this.onListChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DynamicListInputField(
          list: biblicalApostolateList,
          labelText: 'Activities: Biblical Apostolate',
          icon: Icons.book_outlined,
          isRequired: true,
          onListChanged: onListChanged,
        ),
        DynamicListInputField(
          list: liturgyList,
          labelText: 'Activities: Liturgy',
          icon: Icons.church_outlined,
          onListChanged: onListChanged,
        ),
        DynamicListInputField(
          list: financeList,
          labelText: 'Activities: Finance',
          icon: Icons.monetization_on_outlined,
          onListChanged: onListChanged,
        ),
        DynamicListInputField(
          list: familyLifeList,
          labelText: 'Activities: Family Life',
          icon: Icons.favorite_outline,
          onListChanged: onListChanged,
        ),
        DynamicListInputField(
          list: justiceAndPeaceList,
          labelText: 'Activities: Justice and Peace',
          icon: Icons.gavel_outlined,
          onListChanged: onListChanged,
        ),
      ],
    );
  }
}
