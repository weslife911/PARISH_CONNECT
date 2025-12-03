// scc_form.dart (Multi-step Form using PageView)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futru_scc_app/models/scc/create_scc_record_response.dart';
import 'package:futru_scc_app/models/scc/scc_record_model.dart';
import 'package:futru_scc_app/repositories/scc/scc_report_repository.dart'; 
import 'package:futru_scc_app/widgets/helpers.dart';
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
  List<String> _biblicalApostolateList = [];
  List<String> _liturgyList = [];
  List<String> _financeList = [];
  List<String> _familyLifeList = [];
  List<String> _justiceAndPeaceList = [];
  List<String> _youthApostolateList = [];
  List<String> _catecheticalList = [];
  List<String> _healthCareList = [];

  // Step 5: General Report Sections
  List<String> _problemsList = [];
  List<String> _solutionsList = [];
  List<String> _issuesList = [];
  final _nextMonthPlanController = TextEditingController();
  
  // Removed _tempAddItemController 


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
    _nextMonthPlanController.dispose();
    // Disposal for _tempAddItemController removed
    super.dispose();
  }
  
  // --- Navigation Logic ---

  void _nextStep() {
    // Validate the current form step first
    if (!_formKeys[_currentPage].currentState!.validate()) return;
    
    // Custom validation for dates on the first step
    if (_currentPage == 0 && (_periodStart == null || _periodEnd == null)) {
      showToast(context, 'Please select the Period Covered (Start and End Date)', type: ToastificationType.error);
      return;
    }
    
    // Custom validation for required List<String> fields 
    // (This is primarily done in the TextFormField's validator, but a check here is safer)
    if (_currentPage == 2) {
        if (_biblicalApostolateList.isEmpty) {
            showToast(context, 'Activities: Biblical Apostolate is required.', type: ToastificationType.error);
            return;
        }
    }
    if (_currentPage == 4) {
        if (_problemsList.isEmpty) {
            showToast(context, 'Problems Encountered is required.', type: ToastificationType.error);
            return;
        }
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
    }
  }

  // --- Submission Logic ---
  Future<void> _saveForm() async {
    // Final validation before submission
    if (!_formKeys[_currentPage].currentState!.validate()) return;
    
    // Final check for required list fields on the last step
    if (_problemsList.isEmpty || _nextMonthPlanController.text.isEmpty) {
        showToast(context, 'Problems Encountered and Next Month Plan are required.', type: ToastificationType.error);
        return;
    }


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
      // All other activities defaulting to empty list:
      socialCommunicationActivities: [], socialWelfareActivities: [], educationActivities: [],
      vocationActivities: [], dialogueActivities: [], womensAffairsActivities: [],
      mensAffairsActivities: [], prayerAndActionActivities: [],

      // Step 5 General Report Sections
      problemsEncountered: _problemsList,
      proposedSolutions: _solutionsList,
      issuesForCouncil: _issuesList,
      nextMonthPlan: _nextMonthPlanController.text,
    );

    createSccRecordResponseModel = await ref.read(sccReportRepositoryProvider).createSCCReport(newReport);

    if(mounted) {
      showToast(context, createSccRecordResponseModel!.message, type: createSccRecordResponseModel!.success == true ? ToastificationType.success : ToastificationType.error);
    }
    
    if(createSccRecordResponseModel!.success == true) {
      if(mounted) {
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
  
  // --- Dynamic List Input Helper Widget (FIXED CONTROLLER SCOPE) ---

  Widget _buildListInput({
    required List<String> list,
    required String labelText,
    required IconData icon,
    bool isRequired = false,
  }) {
    // Controller is now declared locally inside the build method of the State, 
    // ensuring each instance of _buildListInput gets its own unique controller.
    final TextEditingController _controller = TextEditingController();
    final GlobalKey<FormFieldState> inputKey = GlobalKey<FormFieldState>();

    void addItem() {
      final item = _controller.text;
      if (item.trim().isNotEmpty) {
        setState(() {
          list.add(item.trim());
          _controller.clear(); // Clear only this field's controller
        });
      }
    }
    
    // Dispose the local controller when the widget is removed from the tree
    // Note: Since this is built inside a State class, manual cleanup is often needed, 
    // but for simple text fields within a build method, letting the framework manage it 
    // via a StatelessWidget (or better, a custom StatefulWidget for true isolation) is standard.
    // However, to keep it simple and within the current _SCCFormState:

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (list.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: list.map((item) {
                return Chip(
                  label: Text(item, style: const TextStyle(fontSize: 12)),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    setState(() {
                      list.remove(item);
                      inputKey.currentState?.validate(); // Re-validate after deletion
                    });
                  },
                );
              }).toList(),
            ),
          ),
        
        TextFormField(
          key: inputKey,
          controller: _controller, // UNIQUE CONTROLLER PER INSTANCE
          decoration: InputDecoration(
            labelText: '$labelText ${isRequired ? "*" : ""}',
            prefixIcon: Icon(icon),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: addItem, // Call local addItem
            ),
            hintText: 'Enter new item and press ADD',
          ),
          onFieldSubmitted: (v) => addItem(),
          validator: isRequired && list.isEmpty
              ? (v) => list.isEmpty ? 'At least one item is required.' : null
              : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }


  // --- Step Content Widgets (UNCHANGED) ---

  Widget _buildStepCoreInfo() {
    // All fields are now required
    const String requiredMessage = 'Required';
    return Column(
      children: [
        // Field: Name of SCC (REQUIRED)
        TextFormField(
          controller: _sccNameController,
          decoration: const InputDecoration(labelText: 'Name of SCC *', prefixIcon: Icon(Icons.group)),
          validator: (v) => v == null || v.isEmpty ? requiredMessage : null,
        ),
        const SizedBox(height: 12),
        
        // Field: Period Covered (REQUIRED, validated in _nextStep)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_month_outlined),
          title: Text(_periodStart == null || _periodEnd == null
              ? 'Pick Period Covered (Start & End Date) *'
              : 'Period: ${_periodStart!.day}/${_periodStart!.month}/${_periodStart!.year} to ${_periodEnd!.day}/${_periodEnd!.month}/${_periodEnd!.year}'),
          onTap: () => _pickDateRange(context),
        ),
        const SizedBox(height: 12),

        // All numerical fields are now required
        TextFormField(controller: _totalFamiliesController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total of Families *', prefixIcon: Icon(Icons.family_restroom)), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: _gospelSharingGroupsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gospel Sharing Groups *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: _councilMeetingsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Council Meetings *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: _generalMeetingsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'General Meetings *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildStepMembership() {
    // All fields are now required
    const String requiredMessage = 'Required';
    return Column(
      children: [
        // All fields are now required
        TextFormField(controller: _totalMembershipController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Membership *', prefixIcon: Icon(Icons.people_alt)), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: _childrenController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Children Membership *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: _youthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Youth Membership *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: _adultsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Adults Membership *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 24),

        TextFormField(controller: _gospelSharingExpectedController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gospel Sharing Sessions Expected *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        TextFormField(controller: _gospelSharingDoneController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Gospel Sharing Sessions Done *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 24),

        TextFormField(controller: _baptismController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Baptism Records *'), validator: (v) => v == null || v.isEmpty ? requiredMessage : null,),
        const SizedBox(height: 12),
        // ... other sacramental fields like Lapsed Christians, Irregular Marriages, Burials...
      ],
    );
  }

  Widget _buildStepActivitiesPart1() {
    // Using the new _buildListInput helper
    return Column(
      children: [
        _buildListInput(
          list: _biblicalApostolateList,
          labelText: 'Activities: Biblical Apostolate',
          icon: Icons.book_outlined,
          isRequired: true, // Example required list field
        ),
        _buildListInput(
          list: _liturgyList,
          labelText: 'Activities: Liturgy',
          icon: Icons.church_outlined,
        ),
        _buildListInput(
          list: _financeList,
          labelText: 'Activities: Finance',
          icon: Icons.monetization_on_outlined,
        ),
        _buildListInput(
          list: _familyLifeList,
          labelText: 'Activities: Family Life',
          icon: Icons.favorite_outline,
        ),
        _buildListInput(
          list: _justiceAndPeaceList,
          labelText: 'Activities: Justice and Peace',
          icon: Icons.gavel_outlined,
        ),
      ],
    );
  }

  Widget _buildStepActivitiesPart2() {
    // Using the new _buildListInput helper
    return Column(
      children: [
        _buildListInput(
          list: _youthApostolateList,
          labelText: 'Activities: Youth Apostolate',
          icon: Icons.directions_run_outlined,
        ),
        _buildListInput(
          list: _catecheticalList,
          labelText: 'Activities: Catechetical',
          icon: Icons.school_outlined,
        ),
        _buildListInput(
          list: _healthCareList,
          labelText: 'Activities: Health Care',
          icon: Icons.medical_services_outlined,
        ),
      ],
    );
  }

  Widget _buildStepGeneralReport() {
    // Using the new _buildListInput helper for list fields
    const String requiredMessage = 'Required';
    return Column(
      children: [
        _buildListInput(
          list: _problemsList,
          labelText: 'Problems Encountered',
          icon: Icons.error_outline,
          isRequired: true, // Required
        ),
        _buildListInput(
          list: _solutionsList,
          labelText: 'Proposed Solutions',
          icon: Icons.lightbulb_outline,
        ),
        _buildListInput(
          list: _issuesList,
          labelText: 'Issues to be discussed in the Council',
          icon: Icons.gavel_outlined,
        ),

        // Single line required field
        TextFormField(
          controller: _nextMonthPlanController, 
          maxLines: 5, 
          decoration: const InputDecoration(labelText: 'Plan for the next Month *', prefixIcon: Icon(Icons.event_note_outlined)), 
          validator: (v) => v == null || v.isEmpty ? requiredMessage : null,
        ),
        const SizedBox(height: 24),
        
        // Submission Button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _saveForm, 
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('SUBMIT FINAL REPORT', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
  
  // List of all step widgets
  List<Widget> get _pages => [
    _buildStepCoreInfo(),
    _buildStepMembership(),
    _buildStepActivitiesPart1(),
    _buildStepActivitiesPart2(),
    _buildStepGeneralReport(),
  ];

  // List of step titles for the indicator
  // final List<String> _stepTitles = const [
  //   'Core Info & Dates',
  //   'Membership & Records',
  //   'Commission Activities (1/2)',
  //   'Commission Activities (2/2)',
  //   'General Report & Plan',
  // ];

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
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 32.0), // Reduced top and bottom padding to 4.0
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