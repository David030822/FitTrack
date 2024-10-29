import 'package:fitness_app/models/app_settings.dart';
import 'package:fitness_app/models/food.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class FoodDatabase extends ChangeNotifier {
  static late Isar isar;

  late AppSettings appSettings;

  // List of foods
  final List<Food> currentFoods = [];

  static Future<void> initialize() async {
    try {
      // Prevent reinitialization if already done
      if (Isar.instanceNames.contains('FoodDatabase')) {
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [FoodSchema, AppSettingsSchema],
        directory: dir.path,
        name: 'FoodDatabase',
      );

      // Fetch or initialize app settings
      final existingSettings = await isar.appSettings.get(0);
      if (existingSettings == null) {
        await isar.writeTxn(() async {
          // Explicitly set id = 0
          await isar.appSettings.put(AppSettings()..id = 0);
        });
      }
    } catch (e) {
      debugPrint('Failed to initialize the database: $e');
      rethrow;
    }
  }

  // Fetch the app settings from the database
  Future<void> fetchAppSettings() async {
    // Ensure the database is initialized first
    await initialize();
    appSettings = await isar.appSettings.get(0) ?? AppSettings();
    notifyListeners();
  }

  Future<void> updateCaloriesToBurnGoal(double newGoal) async {
    appSettings.dailyBurnGoal = newGoal;
    await isar.writeTxn(() async {
      await isar.appSettings.put(appSettings);
    });
    notifyListeners();
  }


  // Update the daily goal
  Future<void> updateDailyGoal(double newGoal) async {
    appSettings.dailyIntakeGoal = newGoal;
    await isar.writeTxn(() async {
      await isar.appSettings.put(appSettings);
    });
    notifyListeners();
  }

  // Update the total intake
  Future<void> updateTotalIntake() async {
    appSettings.totalIntake = currentFoods.fold(0, (sum, food) => sum + food.calories);
    await isar.writeTxn(() async {
      await isar.appSettings.put(appSettings);
    });
    notifyListeners();
  }

  // Update the total intake
  Future<void> updateTotalCaloriesBurnt() async {
    appSettings.totalBurnt = workouts.fold(0, (sum, workout) => sum + workout.calories);
    await isar.writeTxn(() async {
      await isar.appSettings.put(appSettings);
    });
    notifyListeners();
  }

  /*

  C R U D X O P E R A T I O N S

  */

  // Add new food
  Future<void> addFood(String foodName, double calories) async {
    final newFood = Food(foodName, calories);
    await isar.writeTxn(() => isar.foods.put(newFood));
    await readFoods();
  }

  // Read foods from the database
  Future<void> readFoods() async {
    currentFoods.clear();
    currentFoods.addAll(await isar.foods.where().findAll());
    await updateTotalIntake(); // Update total intake whenever foods are read
    notifyListeners();
  }

  // Update existing food
  Future<void> updateFood(int id, String newName, double newCalories) async {
    final food = await isar.foods.get(id);
    if (food != null) {
      await isar.writeTxn(() async {
        food.name = newName;
        food.calories = newCalories;
        await isar.foods.put(food);
      });
    }
    await readFoods();
  }

  // Delete food
  Future<void> deleteFood(int id) async {
    await isar.writeTxn(() async {
      await isar.foods.delete(id);
    });
    await readFoods();
  }
}
