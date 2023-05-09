import 'package:flutter/material.dart';
import 'package:habit_tracker/widgets/add_new_habit_dialog.dart';
import 'package:habit_tracker/widgets/habit_tile.dart';
import '../models/habit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habitList = [
    const Habit(habitName: 'Drink Water'),
    const Habit(habitName: 'Run'),
    const Habit(habitName: 'Bathe'),
  ];

  void addHabitToList(String habitName) {
    final Habit habit = Habit(
      habitName: habitName,
      habitValue: false,
    );
    if (habitList.contains(habit)) return;
    setState(() {
      habitList.add(habit);
    });
  }

  void removeHabitFromList(Habit habit) {
    if (!habitList.contains(habit)) return;
    setState(() {
      habitList.remove(habit);
    });
  }

  void removeHabitFromListUsingIndex(int index) {
    setState(() {
      habitList.removeAt(index);
    });
  }

  void createNewHabit() => showDialog(
        context: context,
        builder: (context) => AddNewHabitDialog(
          onSavePressed: addHabitToList,
        ),
      );

  void checkBoxTapped({required int index}) {
    final Habit habitToBeUpdated = habitList.removeAt(index);
    setState(() {
      habitList.insert(
        index,
        Habit(
          habitName: habitToBeUpdated.habitName,
          habitValue: !habitToBeUpdated.habitValue,
        ),
      );
    });
  }

  void onUpdatePressed(int index) {
    final Habit habit = habitList[index];
    showDialog(
      context: context,
      builder: (context) => AddNewHabitDialog(
        initialText: habit.habitName,
        onSavePressed: (newName) {
          updateHabit(
            index: index,
            newHabitName: newName,
          );
        },
      ),
    );
  }

  void updateHabit({required int index, required String newHabitName}) {
    final Habit habitToBeUpdated = habitList.removeAt(index);
    setState(() {
      habitList.insert(
        index,
        Habit(
          habitName: newHabitName,
          habitValue: habitToBeUpdated.habitValue,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            itemCount: habitList.length,
            separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
            itemBuilder: (context, index) {
              final Habit habit = habitList[index];
              return HabitTile(
                habitName: habit.habitName,
                habitCompleted: habit.habitValue,
                onChanged: (_) => checkBoxTapped(index: index),
                onEditTapped: (_) => onUpdatePressed(index),
                onDeleteTapped: (_) => removeHabitFromListUsingIndex(index),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
