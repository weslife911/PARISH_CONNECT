import 'package:flutter/material.dart';

class BuildTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final bool enabled;
  final void Function(String)? onChanged;
  final InputDecoration? decoration;

  const BuildTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.prefixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.decoration, // Allow overriding the entire InputDecoration
  });

  @override
  Widget build(BuildContext context) {
    // If a custom decoration is provided, use it directly.
    // Otherwise, construct a default decoration using provided parameters.
    final effectiveDecoration = decoration ?? InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      border: const OutlineInputBorder(),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        decoration: effectiveDecoration,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        enabled: enabled,
        onChanged: onChanged,
        // Enforce required field validation based on the validator being present
        autovalidateMode: validator != null 
          ? AutovalidateMode.onUserInteraction 
          : AutovalidateMode.disabled,
      ),
    );
  }
}