import 'package:habit_tracker/constants/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/constants.dart';
import '../models/habit.dart';

final Box<Habit> _myBox = Hive.box<Habit>(boxName);
final Box<String> _myDateBox = Hive.box<String>(dateBoxName);

class HabitDatabase {
  final Map<DateTime, int> _heatMapDataSet = {};

  // load existing data
  void loadData() {
    // if it is a new day, get habit list from database
    if (_myDateBox.get(currentDate) == null ||
        _myDateBox.get(currentDate) != todaysDateFormatted()) {
      final List<int> keys = _myBox.keys.cast<int>().toList();
      for (int i = 0; i < keys.length; i++) {
        final Habit currentHabit = _myBox.getAt(keys[i])!;
        _myBox.putAt(keys[i], Habit(habitName: currentHabit.habitName));
      }
      _myDateBox.put(currentDate, todaysDateFormatted());
    }
    refreshHeatMap();
  }

  void saveHabit(Habit habit) {
    _myBox.add(habit);
    refreshHeatMap();
  }

  void updateHabitValue(int key) {
    Habit habit = _myBox.getAt(key)!;
    _myBox.putAt(
      key,
      Habit(
        habitName: habit.habitName,
        habitValue: !habit.habitValue,
      ),
    );
    refreshHeatMap();
  }

  void updateHabit(int key, Habit habit) {
    _myBox.putAt(
      key,
      Habit(
        habitName: habit.habitName,
        habitValue: habit.habitValue,
      ),
    );
    refreshHeatMap();
  }

  void deleteHabit(int key) {
    _myBox.deleteAt(key);
    refreshHeatMap();
  }

  Map<DateTime, int> refreshHeatMap() {
    calculateHabitCompletedPercentages();
    loadHeatMap();
    return _heatMapDataSet;
  }

  void calculateHabitCompletedPercentages() {
    final List<int> keys = _myBox.keys.cast<int>().toList();
    int countCompleted = 0;
    for (int i = 0; i < keys.length; i++) {
      if (_myBox.getAt(keys[i])?.habitValue ?? false) {
        countCompleted += 1;
      }
    }

    String percentage = keys.isEmpty
        ? '0.0'
        : (countCompleted / keys.length).toStringAsFixed(1);
    _myDateBox.put(
      "${percentageSummary}_${todaysDateFormatted()}",
      percentage,
    );
  }

  void loadHeatMap() {
    DateTime startDateObject = createDateTimeObject(
        _myDateBox.get(startDate) ?? todaysDateFormatted());

    //count the number of days in between
    int daysInBetween = DateTime.now().difference(startDateObject).inDays;

    for (int i = 0; i < daysInBetween; i++) {
      final DateTime dateAdded = startDateObject.add(
        Duration(days: i),
      );
      String yyyymmdd = convertDateTimeToString(dateAdded);

      double strength = double.parse(
          _myDateBox.get("${percentageSummary}_$yyyymmdd") ?? "0.0");

      int year = dateAdded.year;
      int month = dateAdded.month;
      int day = dateAdded.day;

      final Map<DateTime, int> percentageForEachDay = {
        DateTime(year, month, day): (10 * strength).toInt(),
      };

      _heatMapDataSet.addEntries(percentageForEachDay.entries);
    }
  }
}
