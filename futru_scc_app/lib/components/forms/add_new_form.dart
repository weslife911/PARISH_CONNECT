import 'package:flutter/material.dart';
import 'package:futru_scc_app/widgets/helpers.dart';
import 'package:toastification/toastification.dart';

class AddNewForm extends StatefulWidget {
  const AddNewForm({super.key, required this.section});
  final String section;
  @override
  State<AddNewForm> createState() => _AddNewFormState();
}

class _AddNewFormState extends State<AddNewForm> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  // 1. Add new controller for 'Function'
  final _function = TextEditingController(); 
  DateTime? _date;
  String? _status;
  String? _location;

  @override
  void dispose() {
    _name.dispose();
    _function.dispose(); // 2. Dispose the new controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            // 3. Conditionally show the 'Function' field for the 'SCC' section
            if (widget.section == 'SCC') ...[
              TextFormField(
                controller: _function,
                decoration: const InputDecoration(
                  labelText: 'Function',
                  prefixIcon: Icon(Icons.settings_suggest_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
            ],
            // You can add similar conditional fields for 'Parish' or 'Deanery' here.
            
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'Active', child: Text('Active')),
                DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
              ],
              onChanged: (v) => setState(() => _status = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _location,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.place_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'North', child: Text('North')),
                DropdownMenuItem(value: 'South', child: Text('South')),
                DropdownMenuItem(value: 'East', child: Text('East')),
                DropdownMenuItem(value: 'West', child: Text('West')),
              ],
              onChanged: (v) => setState(() => _location = v),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(_date == null
                  ? 'Pick a date'
                  : '${_date!.day}/${_date!.month}/${_date!.year}'),
              onTap: () async {
                final now = DateTime.now();
                final res = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year - 5),
                  lastDate: DateTime(now.year + 5),
                  initialDate: now,
                );
                if (res != null) setState(() => _date = res);
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload related PDF'),
              subtitle: const Text('File picker opens here (stubbed in demo)'),
              onTap: () => showToast(context, 'File picker not connected'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    // 4. Access the function value when submitting
                    String functionValue = _function.text; 
                    showToast(context, 
                      'Submitted successfully. Section: ${widget.section}, Function: $functionValue', 
                      type: ToastificationType.success
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}