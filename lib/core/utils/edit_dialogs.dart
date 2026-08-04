import 'package:flutter/material.dart';

/// Shared dialog for editing a short free-text name (user/partner name,
/// reminder message, ...). Used by both the Settings screen and the
/// tap-and-hold quick-edit affordances on the Home screen.
Future<void> showEditTextDialog(
  BuildContext context, {
  required String title,
  required String currentValue,
  required ValueChanged<String> onSave,
  String hintText = 'Optional',
  int maxLines = 1,
}) async {
  final controller = TextEditingController(text: currentValue);
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hintText),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  if (result != null) {
    onSave(result.trim());
  }
}

/// Shared date picker for the relationship start date.
Future<void> showEditStartDateDialog(
  BuildContext context, {
  required DateTime currentValue,
  required ValueChanged<DateTime> onSave,
}) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: currentValue,
    firstDate: DateTime(1970),
    lastDate: DateTime.now(),
  );
  if (picked != null) {
    onSave(picked);
  }
}
