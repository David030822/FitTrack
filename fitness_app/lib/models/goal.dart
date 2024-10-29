import 'package:isar/isar.dart';

part 'goal.g.dart';

@Collection()
class Goal {
  // goal id
  Id id = Isar.autoIncrement;

  // goal name
  late String name;

  // completed days
  List<DateTime> completedDays = [
    // DateTime(year, month, day),
    // DateTime(2024, 8, 22),
    // DateTime(2024, 8, 23),
  ];
}