import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/forms/parish_form.dart';
import 'package:parish_connect/widgets/builds/build_text_form_field.dart';

class StepParishCoreInfo extends ConsumerWidget {
  final ParishFormState parent;
  const StepParishCoreInfo({super.key, required this.parent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String requiredMessage = 'Required';

    Widget buildNumberField({
      required TextEditingController controller,
      required String label,
      required IconData icon,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: BuildTextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.isEmpty)
              ? requiredMessage
              : (int.tryParse(v) == null ? 'Invalid number' : null),
        ),
      );
    }

    String formatDate(DateTime date) =>
        "${date.day}/${date.month}/${date.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1. Basic Information',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        BuildTextFormField(
          controller: parent.commissionNameController,
          decoration: const InputDecoration(
            labelText: 'Name of Commission *',
            prefixIcon: Icon(Icons.account_balance),
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.isEmpty) ? requiredMessage : null,
        ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_month),
          title: Text(
            (parent.periodStart == null)
                ? 'Pick Period Covered *'
                : 'Period: ${formatDate(parent.periodStart!)} to ${formatDate(parent.periodEnd!)}',
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          onTap: () => parent.pickDateRange(context),
        ),
        const SizedBox(height: 24),
        Text(
          '2. Meetings and Membership',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        buildNumberField(
          controller: parent.totalMembersController,
          label: 'Total Members *',
          icon: Icons.people,
        ),
        buildNumberField(
          controller: parent.activeMembersController,
          label: 'Active Members *',
          icon: Icons.person_add,
        ),
        buildNumberField(
          controller: parent.missionsRepresentedController,
          label: 'Missions Represented *',
          icon: Icons.location_city,
        ),
        buildNumberField(
          controller: parent.generalMeetingsController,
          label: 'General Meetings *',
          icon: Icons.meeting_room,
        ),
        buildNumberField(
          controller: parent.excoMeetingsController,
          label: 'EXCO Meetings *',
          icon: Icons.business_center,
        ),
      ],
    );
  }
}
