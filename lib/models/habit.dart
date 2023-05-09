class Habit {
  final String habitName;
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
