// lib/components/steps/parish/step_parish_core_info.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/forms/parish_form.dart';
import 'package:parish_connect/widgets/builds/build_text_form_field.dart';

class StepParishCoreInfo extends ConsumerWidget {
  final ParishFormState parent;

  const StepParishCoreInfo({
    super.key,
    required this.parent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String requiredMessage = 'Required';

    // Helper function for building number fields (unchanged)
    Widget buildNumberField({
      required TextEditingController controller,
      required String labelText,
      required IconData icon,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: BuildTextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return requiredMessage;
            if (int.tryParse(v) == null) return 'Must be a valid whole number';
            return null;
          },
        ),
      );
    }

    // Helper function for reliable date string formatting
    String formatDate(DateTime date) {
      // Formats date as YYYY-MM-DD which is less prone to display errors than day/month/year component access
      return date.toIso8601String().substring(0, 10);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header Section ---
        Text('1. Commission Details & Statistics', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        // Commission Name (unchanged)
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: BuildTextFormField(
            controller: parent.commissionNameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Name of Commission *',
              prefixIcon: Icon(Icons.badge_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (v) => v == null || v.isEmpty ? requiredMessage : null,
          ),
        ),

        // Period Covered Date Range Picker
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_month_outlined),
          // UPDATED: Use a more reliable date string formatting for visibility
          title: Text(parent.periodStart == null || parent.periodEnd == null
              ? 'Pick Period Covered (Start & End Date) *'
              : 'Period: ${formatDate(parent.periodStart!)} to ${formatDate(parent.periodEnd!)}'),
          onTap: () => parent.pickDateRange(context),
        ),

        const SizedBox(height: 16),

        // --- Table Data/Statistics (unchanged) ---
        Text('2. Meetings and Membership Numbers', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),

        buildNumberField(controller: parent.totalMembersController, labelText: 'Total Number of Members *', icon: Icons.people),
        buildNumberField(controller: parent.activeMembersController, labelText: 'Active Members *', icon: Icons.person_add),
        buildNumberField(controller: parent.missionsRepresentedController, labelText: 'Number of Missions Represented *', icon: Icons.location_city),
        buildNumberField(controller: parent.generalMeetingsController, labelText: 'General Meetings *', icon: Icons.meeting_room),
        buildNumberField(controller: parent.excoMeetingsController, labelText: 'EXCO Meetings *', icon: Icons.business_center),

        const SizedBox(height: 24),
      ],
    );
  }
}
