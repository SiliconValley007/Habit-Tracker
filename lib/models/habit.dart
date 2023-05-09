import 'package:hive_flutter/hive_flutter.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  final String habitName;
  @HiveField(1)
  final bool habitValue;

  const Habit({
    required this.habitName,
    this.habitValue = false,
  });

  @override
  bool operator ==(covariant Habit other) {
    if (identical(this, other)) return true;

    return other.habitName == habitName && other.habitValue == habitValue;
  }

  @override
  int get hashCode => habitName.hashCode ^ habitValue.hashCode;
}
