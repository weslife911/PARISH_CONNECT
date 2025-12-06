// parish_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// NOTE: Ensure these imports are correct for your project structure
import 'package:futru_scc_app/components/steps/parish/step_parish_core_info.dart'; 
import 'package:futru_scc_app/components/steps/parish/step_parish_activities.dart';
import 'package:futru_scc_app/components/steps/parish/step_parish_general_report.dart';

import 'package:futru_scc_app/models/parish/create_parish_record_response.dart';
import 'package:futru_scc_app/models/parish/parish_record_model.dart';
import 'package:futru_scc_app/repositories/parish/parish_report_repository.dart'; 
import 'package:futru_scc_app/utils/logger_util.dart'; // Assuming logger is available
import 'package:futru_scc_app/widgets/helpers.dart'; // For showToast
import 'package:toastification/toastification.dart';

class ParishForm extends ConsumerStatefulWidget {
  const ParishForm({super.key}); 
  
  @override
  ConsumerState<ParishForm> createState() => ParishFormState();
}

class ParishFormState extends ConsumerState<ParishForm> { 
  // --- Form Navigation State ---
  int currentPage = 0;
  final PageController pageController = PageController();
  
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(), 
    GlobalKey<FormState>(),
    GlobalKey<FormState>(), 
  ];

  GlobalKey<FormState> get form => formKeys[currentPage]; 


  // --- Data Controllers/Holders (ParishReportModel fields) ---
  final TextEditingController commissionNameController = TextEditingController();
  DateTime? periodStart; 
  DateTime? periodEnd; 

  // Table Data (Controllers for Number Fields)
  final TextEditingController totalMembersController = TextEditingController();
  final TextEditingController missionsRepresentedController = TextEditingController();
  final TextEditingController generalMeetingsController = TextEditingController();
  final TextEditingController activeMembersController = TextEditingController();
  final TextEditingController excoMeetingsController = TextEditingController();

  // Report Sections (List Storage)
  List<String> activities = [];
  List<String> problemsAndSolutions = [];
  List<String> issuesForCouncil = [];
  List<String> futurePlans = [];

  // --- Widget Pages ---
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      StepParishCoreInfo(parent: this),
      StepParishActivities(parent: this),
      StepParishGeneralReport(parent: this),
    ];
  }

  @override
  void dispose() {
    pageController.dispose();
    commissionNameController.dispose();
    totalMembersController.dispose();
    missionsRepresentedController.dispose();
    generalMeetingsController.dispose();
    activeMembersController.dispose();
    excoMeetingsController.dispose();
    super.dispose();
  }

  // Date Range Picker function
  Future<void> pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialDateRange = periodStart != null && periodEnd != null
        ? DateTimeRange(start: periodStart!, end: periodEnd!)
        : DateTimeRange(start: now, end: now); 

    final res = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: initialDateRange,
    );

    if (res != null) {
      setState(() {
        periodStart = res.start;
        periodEnd = res.end;
      });
      logger.d('ParishForm: Dates selected: Start: $periodStart, End: $periodEnd');
    }
  }


  // --- Navigation Logic ---

  void _nextStep() {
    if (!formKeys[currentPage].currentState!.validate()) {
      showToast(context, 'Please fill all required fields in this section.', type: ToastificationType.error);
      return;
    }
    
    // Validation for date range on the first step
    if (currentPage == 0 && (periodStart == null || periodEnd == null)) {
      showToast(context, 'Please select the Period Covered start and end dates.', type: ToastificationType.error);
      return;
    }

    if (currentPage < formKeys.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousStep() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        currentPage--;
      });
    }
  }
  
  // --- Submission Logic ---

  Future<void> _submitReport() async {
    if (!formKeys[currentPage].currentState!.validate()) {
      showToast(context, 'Please complete the final report section.', type: ToastificationType.error);
      return;
    }
    
    if(periodStart == null || periodEnd == null) {
      showToast(context, 'Please select the Period Covered start and end dates.', type: ToastificationType.error);
      return;
    }

    showToast(context, 'Submitting report...', type: ToastificationType.info);
    
    final ParishReportModel report = ParishReportModel(
      commissionName: commissionNameController.text.trim(),
      periodCovered: periodStart!, 
      totalMembers: int.tryParse(totalMembersController.text) ?? 0,
      missionsRepresented: int.tryParse(missionsRepresentedController.text) ?? 0,
      generalMeetings: int.tryParse(generalMeetingsController.text) ?? 0,
      activeMembers: int.tryParse(activeMembersController.text) ?? 0,
      excoMeetings: int.tryParse(excoMeetingsController.text) ?? 0,
      activities: activities,
      problemsAndSolutions: problemsAndSolutions,
      issuesForCouncil: issuesForCouncil,
      futurePlans: futurePlans,
    );

    final repo = ref.read(parishReportRepositoryProvider);
    late CreateParishRecordResponseModel response;

    try {
      response = await repo.createParishReport(report);
      
      // ADDED: Mounted check before using context after async operation
      if (!mounted) return; 
      
      if (response.success) {
        showToast(context, 'Parish Report submitted successfully!', type: ToastificationType.success);
      } else {
        showToast(context, response.message, type: ToastificationType.error);
      }
    } catch (e) {
      // ADDED: Mounted check before using context
      if (!mounted) return; 
      logger.e('Parish Submission Error: $e');
      showToast(context, 'Network or unexpected error occurred.', type: ToastificationType.error);
    }
  }


  @override
  Widget build(BuildContext context) {
    // ... (rest of build method is unchanged)
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKeys[index], 
                  child: _pages[index],
                ),
              );
            },
          ),
        ),
        // ... (Navigation buttons)
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Visibility(
                  visible: currentPage > 0,
                  child: OutlinedButton.icon(
                    onPressed: _previousStep,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
              ),
              if (currentPage > 0 && currentPage < formKeys.length - 1)
                const SizedBox(width: 16),
              
              Expanded(
                child: FilledButton.icon(
                  onPressed: currentPage < formKeys.length - 1 
                      ? _nextStep 
                      : _submitReport, 
                  icon: Icon(currentPage < formKeys.length - 1 
                      ? Icons.arrow_forward 
                      : Icons.send),
                  label: Text(currentPage < formKeys.length - 1 
                      ? 'Next' 
                      : 'Submit'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}