// lib/components/scc_form/steps/step_membership.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepMembership extends ConsumerWidget {
  final TextEditingController totalMembershipController;
  final TextEditingController childrenController;
  final TextEditingController youthController;
  final TextEditingController adultsController;
  final TextEditingController gospelSharingExpectedController;
  final TextEditingController gospelSharingDoneController;
  final TextEditingController baptismController;

  const StepMembership({
    super.key,
    required this.totalMembershipController,
    required this.childrenController,
    required this.youthController,
    required this.adultsController,
    required this.gospelSharingExpectedController,
    required this.gospelSharingDoneController,
    required this.baptismController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String requiredMessage = 'Required';
    return Column(
      children: [
        TextFormField(controller: totalMembershipController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Membership *', prefixIcon: Icon(Icons.people_alt)), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: childrenController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Children Membership *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: youthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Youth Membership *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: adultsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Adults Membership *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 24),

        TextFormField(controller: gospelSharingExpectedController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gospel Sharing Sessions Expected *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: gospelSharingDoneController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gospel Sharing Sessions Done *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 24),

        TextFormField(controller: baptismController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Baptism Records *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
      ],
    );
  }
}