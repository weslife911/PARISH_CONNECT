// lib/components/scc_form/steps/step_core_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepCoreInfo extends ConsumerWidget {
  final TextEditingController sccNameController;
  final TextEditingController totalFamiliesController;
  final TextEditingController gospelSharingGroupsController;
  final TextEditingController councilMeetingsController;
  final TextEditingController generalMeetingsController;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final VoidCallback onPickDateRange;

  const StepCoreInfo({
    super.key,
    required this.sccNameController,
    required this.totalFamiliesController,
    required this.gospelSharingGroupsController,
    required this.councilMeetingsController,
    required this.generalMeetingsController,
    required this.periodStart,
    required this.periodEnd,
    required this.onPickDateRange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String requiredMessage = 'Required';
    return Column(
      children: [
        TextFormField(
          controller: sccNameController,
          decoration: const InputDecoration(labelText: 'Name of SCC *', prefixIcon: Icon(Icons.group)),
          validator: (v) => v == null || v.isEmpty ? requiredMessage : null,
        ),
        const SizedBox(height: 12),
        
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_month_outlined),
          title: Text(periodStart == null || periodEnd == null
              ? 'Pick Period Covered (Start & End Date) *'
              : 'Period: ${periodStart!.day}/${periodStart!.month}/${periodStart!.year} to ${periodEnd!.day}/${periodEnd!.month}/${periodEnd!.year}'),
          onTap: onPickDateRange,
        ),
        const SizedBox(height: 12),

        TextFormField(controller: totalFamiliesController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total of Families *', prefixIcon: Icon(Icons.family_restroom)), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: gospelSharingGroupsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gospel Sharing Groups *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: councilMeetingsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Council Meetings *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: generalMeetingsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'General Meetings *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
      ],
    );
  }
}