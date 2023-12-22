import 'package:isar/isar.dart';
import 'category.dart';

part 'routine.g.dart';

@collection
class Routine {
  Id routineId = Isar.autoIncrement;

  late String title;

  @Index()
  late DateTime startTime;

  @Index(caseSensitive: false)
  late String day;

  @Index(composite: [CompositeIndex('title')])
  final category = IsarLink<Category>();
}
