import 'package:flutter/material.dart';

class AddNewHabitDialog extends StatefulWidget {
  const AddNewHabitDialog({
    super.key,
    this.onSavePressed,
    this.onCancelPressed,
    this.initialText,
  });

  final String? initialText;
  final void Function(String habitName)? onSavePressed;
  final void Function()? onCancelPressed;

  @override
  State<AddNewHabitDialog> createState() => _AddNewHabitDialogState();
}

class _AddNewHabitDialogState extends State<AddNewHabitDialog> {
  late final TextEditingController _habitNameController =
      TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      content: TextField(
        controller: _habitNameController,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          hintText: 'Habit Name',
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            if (_habitNameController.text.isEmpty) return;
            widget.onSavePressed?.call(_habitNameController.text);
            Navigator.pop(context);
          },
          color: Colors.black,
          child: Text(
            widget.initialText == null ? 'Save' : 'Update',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            if (widget.onCancelPressed == null) Navigator.pop(context);
            widget.onCancelPressed?.call();
          },
          color: Colors.black,
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
