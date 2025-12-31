// scc_form.dart (Multi-step Form using PageView)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/components/steps/scc/step_activities_part1.dart';
import 'package:parish_connect/components/steps/scc/step_activities_part2.dart';
import 'package:parish_connect/components/steps/scc/step_core_info.dart';
import 'package:parish_connect/components/steps/scc/step_general_report.dart';
import 'package:parish_connect/components/steps/scc/step_membership.dart';
import 'package:parish_connect/models/scc/create_scc_record_response.dart';
import 'package:parish_connect/models/scc/scc_record_model.dart';
import 'package:parish_connect/repositories/scc/scc_report_repository.dart';
import 'package:parish_connect/utils/logger_util.dart';
import 'package:parish_connect/widgets/helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class SCCForm extends ConsumerStatefulWidget {
  const SCCForm({super.key});

  @override
  ConsumerState<SCCForm> createState() => _SCCFormState();
}

class _SCCFormState extends ConsumerState<SCCForm> {
  CreateSccRecordResponseModel? createSccRecordResponseModel;
  // --- Navigation & Validation State ---
  final PageController _pageController = PageController();
  int _currentPage = 0;
  // Create a form key for each step to validate independently
  final List<GlobalKey<FormState>> _formKeys =
      List.generate(5, (_) => GlobalKey<FormState>());

  // --- Report Data Controllers (for non-list fields) ---

  // Step 1: Core Info
  final _sccNameController = TextEditingController();
  DateTime? _periodStart;
  DateTime? _periodEnd;
  final _totalFamiliesController = TextEditingController();
  final _gospelSharingGroupsController = TextEditingController();
  final _councilMeetingsController = TextEditingController();
  final _generalMeetingsController = TextEditingController();

  // Step 2: Membership & Sacramental
  final _totalMembershipController = TextEditingController();
  final _childrenController = TextEditingController();
  final _youthController = TextEditingController();
  final _adultsController = TextEditingController();
  final _gospelSharingExpectedController = TextEditingController();
  final _gospelSharingDoneController = TextEditingController();
  final _baptismController = TextEditingController();

  // --- List<String> State Variables ---

  // Step 3 & 4: Commission Activities
  final List<String> _biblicalApostolateList = [];
  final List<String> _liturgyList = [];
  final List<String> _financeList = [];
  final List<String> _familyLifeList = [];
  final List<String> _justiceAndPeaceList = [];
  final List<String> _youthApostolateList = [];
  final List<String> _catecheticalList = [];
  final List<String> _healthCareList = [];

  // Step 5: General Report Sections
  final List<String> _problemsList = [];
  final List<String> _solutionsList = [];
  final List<String> _issuesList = [];
  final List<String> _nextMonthPlansList = [];

  // This is used to force a rebuild on the last page when a list item is added/removed,
  // which re-runs the list validation logic check in _nextStep and _saveForm.
  void _onListChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sccNameController.dispose();
    _totalFamiliesController.dispose();
    _gospelSharingGroupsController.dispose();
    _councilMeetingsController.dispose();
    _generalMeetingsController.dispose();
    _totalMembershipController.dispose();
    _childrenController.dispose();
    _youthController.dispose();
    _adultsController.dispose();
    _gospelSharingExpectedController.dispose();
    _gospelSharingDoneController.dispose();
    _baptismController.dispose();
    super.dispose();
  }

  // --- Navigation Logic ---

  void _nextStep() {
    logger.d('SCCForm: Navigating from Step $_currentPage');

    // Validate the current form step first
    if (!_formKeys[_currentPage].currentState!.validate()) {
      logger.w('SCCForm: Validation failed on current page ($_currentPage). Stopping navigation.');
      return;
    }

    // Custom validation for dates on the first step
    if (_currentPage == 0 && (_periodStart == null || _periodEnd == null)) {
      showToast(context, 'Please select the Period Covered (Start and End Date)', type: ToastificationType.error);
      logger.w('SCCForm: Step 0 Date validation failed (Dates are null).');
      return;
    }

    // Custom validation for required List<String> fields
    // Biblical Apostolate is required on step 2 (index 2)
    if (_currentPage == 2) {
        if (_biblicalApostolateList.isEmpty) {
            showToast(context, 'Activities: Biblical Apostolate is required.', type: ToastificationType.error);
            logger.w('SCCForm: Step 2 List validation failed (Biblical Apostolate is empty).');
            return;
        }
    }
    // Problems Encountered is required on step 4 (index 4)
    // NOTE: This is checked here, but the actual save check will handle the submit button.
    if (_currentPage == 4) {
        if (_problemsList.isEmpty) {
            showToast(context, 'Problems Encountered is required.', type: ToastificationType.error);
            logger.w('SCCForm: Step 4 List validation failed (Problems Encountered is empty).');
            return;
        }
        if (_nextMonthPlansList.isEmpty) {
            showToast(context, 'Plan for the next Month is required.', type: ToastificationType.error);
            logger.w('SCCForm: Step 4 List validation failed (Next Month Plan is empty).');
            return;
        }
    }

    if (_currentPage < _formKeys.length - 1) {
      logger.d('SCCForm: Validation passed on Step $_currentPage. Moving to next page.');
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousStep() {
    if (_currentPage > 0) {
      logger.d('SCCForm: Navigating back from Step $_currentPage.');
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialDateRange = _periodStart != null && _periodEnd != null
        ? DateTimeRange(start: _periodStart!, end: _periodEnd!)
        : DateTimeRange(start: now, end: now);

    final res = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: initialDateRange,
    );

    if (res != null) {
      setState(() {
        _periodStart = res.start;
        _periodEnd = res.end;
      });
      logger.d('SCCForm: Dates selected: Start: $_periodStart, End: $_periodEnd');
    }
  }

  // --- Submission Logic ---
  Future<void> _saveForm() async {
    // Final validation before submission
    if (!_formKeys[_currentPage].currentState!.validate()) {
      logger.w('SCCForm: Final validation failed on the last page before submission.');
      return;
    }

    // Final check for required list fields
    if (_problemsList.isEmpty) {
        showToast(context, 'Problems Encountered is a required field.', type: ToastificationType.error);
        logger.w('SCCForm: Final check failed: Problems Encountered list is empty.');
        return;
    }
    if (_nextMonthPlansList.isEmpty) {
        showToast(context, 'Plan for the next Month is a required field.', type: ToastificationType.error);
        logger.w('SCCForm: Final check failed: Next Month Plan list is empty.');
        return;
    }

    // DEBUG: Log the collected non-list data before model creation
    logger.i('SCCForm: --- REPORT SUBMISSION INITIATED ---');
    logger.i('SCCForm: SCC Name: ${_sccNameController.text}');
    logger.i('SCCForm: Period: $_periodStart to $_periodEnd');
    logger.i('SCCForm: Total Families: ${_totalFamiliesController.text}');
    logger.i('SCCForm: Total Membership: ${_totalMembershipController.text}');
    logger.i('SCCForm: Biblical Apostolate Items: ${_biblicalApostolateList.length}');
    logger.i('SCCForm: Problems Encountered Items: ${_problemsList.length}');
    logger.i('SCCForm: Next Month Plan Items: ${_nextMonthPlansList.length}');


    final newReport = SccReportModel(
      sccName: _sccNameController.text,
      periodStart: _periodStart!,
      periodEnd: _periodEnd!,

      // Step 1 Core
      totalFamilies: int.tryParse(_totalFamiliesController.text) ?? 0,
      gospelSharingGroups: int.tryParse(_gospelSharingGroupsController.text) ?? 0,
      councilMeetings: int.tryParse(_councilMeetingsController.text) ?? 0,
      generalMeetings: int.tryParse(_generalMeetingsController.text) ?? 0,
      noOfCommissions: 0, activeCommissions: 0, // Placeholder

      // Step 2 Membership & Sacramental
      totalMembership: int.tryParse(_totalMembershipController.text) ?? 0,
      children: int.tryParse(_childrenController.text) ?? 0,
      youth: int.tryParse(_youthController.text) ?? 0,
      adults: int.tryParse(_adultsController.text) ?? 0,
      gospelSharingExpected: int.tryParse(_gospelSharingExpectedController.text) ?? 0,
      gospelSharingDone: int.tryParse(_gospelSharingDoneController.text) ?? 0,
      noChristiansAttendingGS: 0, // Placeholder
      gsAttendancePercentage: 0.0, // Placeholder
      baptism: int.tryParse(_baptismController.text) ?? 0,
      lapsedChristians: 0, irregularMarriages: 0, burials: 0, // Placeholder

      // Step 3 & 4 Activities (USING LIST STATE DIRECTLY)
      biblicalApostolateActivities: _biblicalApostolateList,
      liturgyActivities: _liturgyList,
      financeActivities: _financeList,
      familyLifeActivities: _familyLifeList,
      justiceAndPeaceActivities: _justiceAndPeaceList,
      youthApostolateActivities: _youthApostolateList,
      catecheticalActivities: _catecheticalList,
      healthCareActivities: _healthCareList,
      socialCommunicationActivities: [], socialWelfareActivities: [], educationActivities: [],
      vocationActivities: [], dialogueActivities: [], womensAffairsActivities: [],
      mensAffairsActivities: [], prayerAndActionActivities: [],

      // Step 5 General Report Sections
      problemsEncountered: _problemsList,
      proposedSolutions: _solutionsList,
      issuesForCouncil: _issuesList,
      nextMonthPlans: _nextMonthPlansList,
    );

    logger.d('SCCForm: Full JSON Payload: ${newReport.toJson()}');

    createSccRecordResponseModel = await ref.read(sccReportRepositoryProvider).createSCCReport(newReport);

    logger.i('SCCForm: Repository Response - Success: ${createSccRecordResponseModel!.success}, Message: ${createSccRecordResponseModel!.message}');


    if(mounted) {
      showToast(context, createSccRecordResponseModel!.message, type: createSccRecordResponseModel!.success == true ? ToastificationType.success : ToastificationType.error);
    }

    if(createSccRecordResponseModel!.success == true) {
      if(mounted) {
        logger.i('SCCForm: Submission successful. Navigating to section page.');
        context.pushNamed(
          'section',
          extra: {
            'title': "SCC",
            'initialTabIndex': 1,
          },
        );
      }
    }

  }

  // --- Step Content Widgets (NOW USING SEPARATED WIDGETS) ---

  List<Widget> get _pages => [
    StepCoreInfo(
      sccNameController: _sccNameController,
      totalFamiliesController: _totalFamiliesController,
      gospelSharingGroupsController: _gospelSharingGroupsController,
      councilMeetingsController: _councilMeetingsController,
      generalMeetingsController: _generalMeetingsController,
      periodStart: _periodStart,
      periodEnd: _periodEnd,
      onPickDateRange: () => _pickDateRange(context),
    ),
    StepMembership(
      totalMembershipController: _totalMembershipController,
      childrenController: _childrenController,
      youthController: _youthController,
      adultsController: _adultsController,
      gospelSharingExpectedController: _gospelSharingExpectedController,
      gospelSharingDoneController: _gospelSharingDoneController,
      baptismController: _baptismController,
    ),
    StepActivitiesPart1(
      biblicalApostolateList: _biblicalApostolateList,
      liturgyList: _liturgyList,
      financeList: _financeList,
      familyLifeList: _familyLifeList,
      justiceAndPeaceList: _justiceAndPeaceList,
      onListChanged: _onListChanged,
    ),
    StepActivitiesPart2(
      youthApostolateList: _youthApostolateList,
      catecheticalList: _catecheticalList,
      healthCareList: _healthCareList,
      onListChanged: _onListChanged,
    ),
    StepGeneralReport(
      problemsList: _problemsList,
      solutionsList: _solutionsList,
      issuesList: _issuesList,
      nextMonthPlansList: _nextMonthPlansList,
      onSaveForm: _saveForm,
      onListChanged: _onListChanged,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Step Indicator ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Row(
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
                        color: index == _currentPage ? Theme.of(context).primaryColor : Colors.grey.shade300,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: index <= _currentPage ? Theme.of(context).primaryColor : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: index == _currentPage ? Colors.white : Colors.black87,
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
        ),

        const Divider(height: 0),

        // --- Page View (Animated Step Content) ---
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swiping
            itemCount: _formKeys.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                logger.d('SCCForm: PageView changed to Step $_currentPage.');
              });
            },
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKeys[index],
                  child: _pages[index],
                ),
              );
            },
          ),
        ),

        // --- Navigation Buttons ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Button
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

              // Next/Submit Button (Show Next button until the last page)
              Expanded(
                child: Visibility(
                  visible: _currentPage < _formKeys.length - 1,
                  replacement: const SizedBox.shrink(), // Hides the button on the last page
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
