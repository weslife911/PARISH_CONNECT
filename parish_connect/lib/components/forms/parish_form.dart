import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parish_connect/components/steps/parish/step_parish_core_info.dart';
import 'package:parish_connect/components/steps/parish/step_parish_activities.dart';
import 'package:parish_connect/components/steps/parish/step_parish_general_report.dart';
import 'package:parish_connect/models/parish/parish_record_model.dart';
import 'package:parish_connect/repositories/auth/check_auth_repository.dart';
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
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    3,
    (_) => GlobalKey<FormState>(),
  );

  final commissionNameController = TextEditingController();
  DateTime? periodStart;
  DateTime? periodEnd;

  final totalMembersController = TextEditingController();
  final missionsRepresentedController = TextEditingController();
  final generalMeetingsController = TextEditingController();
  final activeMembersController = TextEditingController();
  final excoMeetingsController = TextEditingController();

  final List<String> activities = [];
  final List<String> problemsAndSolutions = [];
  final List<String> issuesForCouncil = [];
  final List<String> futurePlans = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    commissionNameController.dispose();
    totalMembersController.dispose();
    missionsRepresentedController.dispose();
    generalMeetingsController.dispose();
    activeMembersController.dispose();
    excoMeetingsController.dispose();
    super.dispose();
  }

  void _onListChanged() => setState(() {});

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

  void _nextStep() {
    if (!_formKeys[_currentPage].currentState!.validate()) return;

    if (_currentPage == 0 && (periodStart == null || periodEnd == null)) {
      showToast(
        context,
        'Please select the Period Covered',
        type: ToastificationType.error,
      );
      return;
    }

    if (_currentPage < _formKeys.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousStep() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _submitReport() async {
    if (!_formKeys[_currentPage].currentState!.validate()) return;

    if (activities.isEmpty) {
      showToast(
        context,
        'Activities Carried Out is required.',
        type: ToastificationType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final report = ParishReportModel(
        commissionName: commissionNameController.text.trim(),
        periodCovered: periodStart!,
        totalMembers: int.tryParse(totalMembersController.text) ?? 0,
        activeMembers: int.tryParse(activeMembersController.text) ?? 0,
        missionsRepresented:
            int.tryParse(missionsRepresentedController.text) ?? 0,
        generalMeetings: int.tryParse(generalMeetingsController.text) ?? 0,
        excoMeetings: int.tryParse(excoMeetingsController.text) ?? 0,
        activities: List.from(activities),
        problemsAndSolutions: List.from(problemsAndSolutions),
        issuesForCouncil: List.from(issuesForCouncil),
        futurePlans: List.from(futurePlans),
      );

      final response = await ref
          .read(parishReportRepositoryProvider)
          .createParishReport(report);

      if (mounted) {
        showToast(
          context,
          response.message,
          type: response.success
              ? ToastificationType.success
              : ToastificationType.error,
        );
        if (response.success == true) {
          logger.i(
            'Parish Form: Submission successful. Navigating to section page.',
          );
          ref.invalidate(getParishRecordsFutureProvider);
          context.pushNamed(
            'section',
            extra: {'title': "Parish", 'initialTabIndex': 1},
          );
        }
      }
    } catch (e) {
      logger.e("ParishForm: Submission error", error: e);
      if (mounted)
        showToast(context, 'Error: $e', type: ToastificationType.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Text(
                ref.read(checkAuthRepositoryStateProvider)!.user!.parish,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_formKeys.length, (index) {
                  return Flexible(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: index == _currentPage
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: index <= _currentPage
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: index == _currentPage
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _formKeys.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKeys[index],
                  child: [
                    StepParishCoreInfo(parent: this),
                    StepParishActivities(
                      parent: this,
                      onListChanged: _onListChanged,
                    ),
                    StepParishGeneralReport(
                      parent: this,
                      isLoading: _isLoading,
                      onSaveForm: _submitReport,
                      onListChanged: _onListChanged,
                    ),
                  ][index],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Visibility(
                  visible: _currentPage > 0,
                  child: OutlinedButton.icon(
                    onPressed: _previousStep,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                ),
              ),
              if (_currentPage > 0 && _currentPage < _formKeys.length - 1)
                const SizedBox(width: 16),
              Expanded(
                child: Visibility(
                  visible: _currentPage < _formKeys.length - 1,
                  replacement: const SizedBox.shrink(),
                  child: FilledButton.icon(
                    onPressed: _nextStep,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
