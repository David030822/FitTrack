import 'package:isar/isar.dart';

// run cmd to generate file: dart run build_runner build
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
  double dailyBurnGoal = 0;
  double dailyIntakeGoal = 0;
  double totalBurnt = 0;
  double totalIntake = 0;
}