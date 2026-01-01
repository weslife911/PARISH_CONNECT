import 'package:flutter/material.dart';

Widget buildField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required bool enabled,
  int maxLines = 1,
  required BuildContext context
}) {
  return TextFormField(
    controller: controller,
    enabled: enabled,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      filled: !enabled,
      fillColor: enabled
          ? Colors.transparent
          : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
    ),
  );
}
