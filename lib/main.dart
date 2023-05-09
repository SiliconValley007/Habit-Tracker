import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/constants.dart';
import 'models/habit.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  //initialize Hive db
  Hive.init(dir.path);
  Hive.registerAdapter(HabitAdapter());

  //open a box
  await Hive.openBox<Habit>(boxName);
  await Hive.openBox<String>(dateBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const HomeScreen(),
    );
  }
}
