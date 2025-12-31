import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parish_connect/utils/logger_util.dart'; // Ensure this import is correct

class DynamicListInputField extends ConsumerStatefulWidget {
  final List<String> list;
  final String labelText;
  final IconData icon;
  final bool isRequired;
  final GlobalKey<FormFieldState>? inputKey;
  final Function() onListChanged; // Callback to notify the parent of state change

  const DynamicListInputField({
    super.key,
    required this.list,
    required this.labelText,
    required this.icon,
    this.isRequired = false,
    this.inputKey,
    required this.onListChanged,
  });

  @override
  ConsumerState<DynamicListInputField> createState() => _DynamicListInputFieldState();
}

class _DynamicListInputFieldState extends ConsumerState<DynamicListInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addItem() {
    final item = _controller.text;
    if (item.trim().isNotEmpty) {
      setState(() {
        widget.list.add(item.trim());
        _controller.clear();
        widget.onListChanged(); // Notify parent of change
        widget.inputKey?.currentState?.validate(); // Force validation check
        logger.d('SCCForm: Added item to "${widget.labelText}" list. New length: ${widget.list.length}');
      });
    }
  }

  void _removeItem(String item) {
    setState(() {
      widget.list.remove(item);
      widget.onListChanged(); // Notify parent of change
      widget.inputKey?.currentState?.validate(); // Force validation check
      logger.d('SCCForm: Removed item from "${widget.labelText}" list. New length: ${widget.list.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.list.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.list.map((item) {
                return Chip(
                  label: Text(item, style: const TextStyle(fontSize: 12)),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => _removeItem(item),
                );
              }).toList(),
            ),
          ),

        TextFormField(
          key: widget.inputKey,
          controller: _controller,
          decoration: InputDecoration(
            labelText: '${widget.labelText} ${widget.isRequired ? "*" : ""}',
            prefixIcon: Icon(widget.icon),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: _addItem,
            ),
            hintText: 'Enter new item and press ADD',
          ),
          onFieldSubmitted: (v) => _addItem(),
          validator: widget.isRequired && widget.list.isEmpty
              ? (v) => widget.list.isEmpty ? 'At least one item is required.' : null
              : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
