// lib/components/forms/parish_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:parish_connect/components/steps/parish/step_parish_core_info.dart';
import 'package:parish_connect/components/steps/parish/step_parish_activities.dart';
import 'package:parish_connect/components/steps/parish/step_parish_general_report.dart';
import 'package:parish_connect/config/api_keys.dart';
import 'package:parish_connect/models/parish/parish_record_model.dart';
import 'package:parish_connect/repositories/parish/parish_report_repository.dart';
import 'package:parish_connect/utils/logger_util.dart';
import 'package:parish_connect/widgets/helpers.dart';
import 'package:toastification/toastification.dart';

class ParishForm extends ConsumerStatefulWidget {
  const ParishForm({super.key});

  @override
  ConsumerState<ParishForm> createState() => ParishFormState();
}

class ParishFormState extends ConsumerState<ParishForm> {
  int currentPage = 0;
  final PageController pageController = PageController();
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // --- Public Data Controllers (Fixed naming for child access) ---
  final TextEditingController commissionNameController =
      TextEditingController();
  DateTime? periodStart;
  DateTime? periodEnd;

  final TextEditingController totalMembersController = TextEditingController();
  final TextEditingController missionsRepresentedController =
      TextEditingController();
  final TextEditingController generalMeetingsController =
      TextEditingController();
  final TextEditingController activeMembersController = TextEditingController();
  final TextEditingController excoMeetingsController = TextEditingController();

  List<String> activities = [];
  List<String> problemsAndSolutions = [];
  List<String> issuesForCouncil = [];
  List<String> futurePlans = [];

  // --- AI Configuration ---
  late final GenerativeModel _model;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiApiKey);
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

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDateRange: (periodStart != null && periodEnd != null)
          ? DateTimeRange(start: periodStart!, end: periodEnd!)
          : null,
    );

    if (picked != null) {
      setState(() {
        periodStart = picked.start;
        periodEnd = picked.end;
      });
    }
  }

  // AI Logic to enhance the report
  Future<String> _enhanceText(String input) async {
    // If input is empty or AI model failed to initialize, return original text
    if (input.trim().isEmpty) return input;

    try {
      final prompt =
          "As a professional church secretary, rewrite this parish report entry to be more professional, "
          "grammatically correct, and concise: $input";

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      // Return enhanced text if available, otherwise return original
      return response.text ?? input;
    } catch (e) {
      debugPrint("AI Enhancement failed: $e");
      return input;
    }
  }

  void _nextStep() {
    logger.i("Attempting to move to next step. Current page: $currentPage");

    final bool isFormValid =
        formKeys[currentPage].currentState?.validate() ?? false;

    if (isFormValid) {
      if (currentPage < 2) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        setState(() {
          currentPage++;
        });
        logger.d("Moved to page $currentPage");
      }
    } else {
      logger.w("Form validation failed for page $currentPage");
    }
  }

  Future<void> _submitReport() async {
    logger.i("Starting submission process...");

    // Log the state of dates
    logger.d("periodStart: $periodStart, periodEnd: $periodEnd");

    if (periodStart == null || periodEnd == null) {
      logger.w("Submission blocked: Dates are null.");
      showToast(
        context,
        'Please select a report period.',
        type: ToastificationType.warning,
      );
      return;
    }

    if (formKeys[currentPage].currentState?.validate() ?? false) {
      setState(() => isProcessing = true);

      try {
        logger.i("Enhancing text with AI...");
        final List<String> enhancedActivities = await Future.wait(
          activities.map((item) => _enhanceText(item)),
        );

        // DEBUG: Log all controller values before Model creation
        logger.d("Commission: ${commissionNameController.text}");
        logger.d(
          "Stats: Total(${totalMembersController.text}), Active(${activeMembersController.text})",
        );

        final report = ParishReportModel(
          commissionName: commissionNameController.text.trim(),
          periodCovered:
              periodStart!, // If it crashes here, the log above will show periodStart was null
          totalMembers: int.tryParse(totalMembersController.text) ?? 0,
          activeMembers: int.tryParse(activeMembersController.text) ?? 0,
          missionsRepresented:
              int.tryParse(missionsRepresentedController.text) ?? 0,
          generalMeetings: int.tryParse(generalMeetingsController.text) ?? 0,
          excoMeetings: int.tryParse(excoMeetingsController.text) ?? 0,
          activities: enhancedActivities,
          problemsAndSolutions: List.from(problemsAndSolutions),
          issuesForCouncil: List.from(issuesForCouncil),
          futurePlans: List.from(futurePlans),
        );

        logger.i("Sending report to repository...");
        final repository = ref.read(parishReportRepositoryProvider);
        final response = await repository.createParishReport(report);

        if (response.success) {
          logger.i("Submission successful!");
          if(mounted) {
            showToast(
              context,
              'Submitted Successfully',
              type: ToastificationType.success,
            );
          }
          if (mounted) Navigator.pop(context);
        } else {
          logger.e("Server rejected submission: ${response.message}");
        }
      } catch (e, stackTrace) {
        // This will catch the Null Check error and print the EXACT line number
        logger.e("CRITICAL SUBMISSION ERROR", error: e, stackTrace: stackTrace);
        if(mounted) {
          showToast(context, 'Error: $e', type: ToastificationType.error);
        }
      } finally {
        if (mounted) setState(() => isProcessing = false);
      }
    } else {
      logger.w("Form validation failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (isProcessing) const LinearProgressIndicator(),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Form(
                  key: formKeys[0],
                  child: StepParishCoreInfo(parent: this),
                ),
                Form(
                  key: formKeys[1],
                  child: StepParishActivities(parent: this),
                ),
                Form(
                  key: formKeys[2],
                  child: StepParishGeneralReport(parent: this),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 0)
                  TextButton(
                    onPressed: () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                      setState(() => currentPage--);
                    },
                    child: const Text("Back"),
                  ),
                ElevatedButton(
                  onPressed: currentPage < 2 ? _nextStep : _submitReport,
                  child: Text(currentPage < 2 ? "Next" : "AI Submit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
