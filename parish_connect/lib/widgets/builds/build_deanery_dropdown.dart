import 'package:flutter/material.dart';
import 'package:parish_connect/constants.dart';

Widget buildDeaneryDropdown({
  required String? selectedDeanery,
  required ValueChanged<String?> onChanged, // Pass the function here
}) {
  return DropdownButtonFormField<String>(
    initialValue: selectedDeanery,
    isExpanded: true,
    decoration: InputDecoration(
      labelText: 'Deanery',
      prefixIcon: const Icon(Icons.map_outlined),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    items: deaneryParishMap.keys
        .map((d) => DropdownMenuItem(
              value: d,
              child: Text(d, overflow: TextOverflow.ellipsis),
            ))
        .toList(),
    onChanged: onChanged, // Trigger the callback passed from parent
  );
}
