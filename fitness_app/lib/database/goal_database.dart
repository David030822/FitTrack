import 'package:fitness_app/models/app_settings.dart';
import 'package:fitness_app/models/goal.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class GoalDatabase extends ChangeNotifier {
  static late Isar isar;

  /*

  S E T U P

  */

  // I N I T I A L I Z E - D A T A B A S E
  static Future<void> initialize() async {
  try {
    // Check if the database is already initialized to avoid re-initialization
    if (Isar.instanceNames.contains('GoalDatabase')) {
      return;
    }

    // Obtain the application documents directory
    final dir = await getApplicationDocumentsDirectory();

    // Open the Isar database with the provided schemas
    isar = await Isar.open(
      [GoalSchema, AppSettingsSchema],
      directory: dir.path,
      name: 'GoalDatabase'
    );
  } catch (e) {
    // Handle any errors during initialization
    debugPrint('Failed to initialize the database: $e');
    rethrow;
  }
}

  // save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if(existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*

  C R U D X O P E R A T I O N S

  */

  // list of goals
  final List<Goal> currentGoals = [];

  // C R E A T E - add new goal
  Future<void> addGoal(String goalName) async {
    // create new goal
    final newGoal = Goal()..name = goalName;

    // save to db
    await isar.writeTxn(() => isar.goals.put(newGoal));

    // re-read from db
    readGoals();
  }

  // R E A D - read saved goals from db
  Future<void> readGoals() async {
    // fetch all goals from db
    List<Goal> fetchedGoals = await isar.goals.where().findAll();

    // give to current goals
    currentGoals.clear();
    currentGoals.addAll(fetchedGoals);

    // update UI
    notifyListeners();
  }

  // U P D A T E - check goal on and off
  Future<void> updateGoalCompletion(int id, bool isCompleted) async {
    // find the specific goal
    final goal = await isar.goals.get(id);

    // update completion status
    if(goal != null) {
      await isar.writeTxn(() async {
        // if goal is completed -> add the current date to the completedDays list
        if(isCompleted && !goal.completedDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();

          // add the current date
          goal.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        }

        // if goal is NOT completed -> remove the current date from the list
        else {
          // remove current date
          goal.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        // save the updated goals back to the db
        await isar.goals.put(goal);
      });
    }

    // re-read from db
    readGoals();
  }

  // U P D A T E - edit goal name
  Future<void> updateGoalName(int id, String newName) async {
    // find the specific goal
    final goal = await isar.goals.get(id);

    // update goal name
    if(goal != null) {
      // update name
      await isar.writeTxn(() async {
        goal.name = newName;
        // save updated goal back to the db
        await isar.goals.put(goal);
      });
    }

    // re-read from db
    readGoals();
  }

  // D E L E T E - delete goal
  Future<void> deleteGoal(int id) async {
    // perform the delete
    await isar.writeTxn(() async {
      await isar.goals.delete(id);
    });

    // re-read from db
    readGoals();
  }
}