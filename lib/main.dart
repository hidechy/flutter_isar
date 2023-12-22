import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'screens/home_screen.dart';
import 'collections/category.dart';
import 'collections/routine.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationSupportDirectory();

  final isar = await Isar.open([RoutineSchema, CategorySchema], directory: dir.path);

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isar});

  final Isar isar;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      home: HomeScreen(isar: isar),
    );
  }
}
