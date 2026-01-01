import 'package:flutter/material.dart';
import 'package:parish_connect/constants.dart';

Widget buildParishDropdown(String? selectedParish, String? selectedDeanery, ValueChanged<String?> onChanged,
) {
  return DropdownButtonFormField<String>(
    initialValue: selectedParish,
    isExpanded: true, // FIX: Prevents RenderFlex overflow
    decoration: InputDecoration(
      labelText: 'Parish',
      prefixIcon: const Icon(Icons.church_outlined),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    items: (selectedDeanery == null)
        ? []
        : deaneryParishMap[selectedDeanery]!
              .map(
                (p) => DropdownMenuItem(
                  value: p,
                  child: Text(p, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
    onChanged: onChanged,
  );
}
