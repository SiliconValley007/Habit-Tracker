import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    this.onChanged,
    this.onEditTapped,
    this.onDeleteTapped,
  });

  final String habitName;
  final bool habitCompleted;
  final void Function(bool? value)? onChanged;
  final void Function(BuildContext context)? onEditTapped;
  final void Function(BuildContext context)? onDeleteTapped;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          //edit option
          SlidableAction(
            onPressed: onEditTapped,
            backgroundColor: Colors.green.shade800,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(12),
          ),
          //delete option
          SlidableAction(
            onPressed: onDeleteTapped,
            backgroundColor: Colors.red.shade800,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Checkbox(
              value: habitCompleted,
              onChanged: onChanged,
            ),
            Text(habitName),
          ],
        ),
      ),
    );
  }
}
