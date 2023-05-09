import 'package:flutter/material.dart';
import 'package:habit_tracker/constants/date_time.dart';
import 'package:habit_tracker/widgets/monthly_summary.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/constants.dart';
import '../database/habit_database.dart';
import '../models/habit.dart';
import '../widgets/add_new_habit_dialog.dart';
import '../widgets/habit_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HabitDatabase db = HabitDatabase();
  late final Box<Habit> myBox;
  late final Box<String> dateBox;

  @override
  void initState() {
    super.initState();
    db.loadData();
    myBox = Hive.box<Habit>(boxName);
    dateBox = Hive.box<String>(dateBoxName);
    if (dateBox.get(startDate) == null) {
      dateBox.put(startDate, todaysDateFormatted());
    }
  }

  void createNewHabit() => showDialog(
        context: context,
        builder: (context) => AddNewHabitDialog(
          onSavePressed: (value) => db.saveHabit(Habit(habitName: value)),
        ),
      );

  void onUpdatePressed(int key, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AddNewHabitDialog(
        initialText: habit.habitName,
        onSavePressed: (newName) {
          db.updateHabit(
            key,
            Habit(
              habitName: newName,
              habitValue: habit.habitValue,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: ValueListenableBuilder<Box<Habit>>(
          valueListenable: myBox.listenable(),
          builder: (context, items, child) {
            final List<int> keys = items.keys.cast<int>().toList();
            if (keys.isEmpty) {
              return const Center(
                child: Text(
                  'Please Mention your habits',
                  textAlign: TextAlign.center,
                ),
              );
            }
            return Column(
              children: [
                MonthlySummary(
                  startDate: dateBox.get(startDate) ?? todaysDateFormatted(),
                  datasets: db.refreshHeatMap(),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    itemCount: keys.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemBuilder: (context, index) {
                      final int key = keys[index];
                      final Habit? habit = items.get(key);
                      if (habit == null) {
                        return const SizedBox.shrink();
                      }
                      return HabitTile(
                        habitName: habit.habitName,
                        habitCompleted: habit.habitValue,
                        onChanged: (_) => db.updateHabitValue(key),
                        onEditTapped: (_) => onUpdatePressed(key, habit),
                        onDeleteTapped: (_) => db.deleteHabit(key),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
