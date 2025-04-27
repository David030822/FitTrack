import 'package:fitness_app/components/food_tile.dart';
import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/models/calories_goals.dart';
import 'package:fitness_app/models/meal.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/util/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final api = ApiService();
  final _foodNameController = TextEditingController();
  final _foodDescriptionController = TextEditingController();
  final _foodCaloriesController = TextEditingController();
  final _caloriesController = TextEditingController();
  List<Meal> _userMeals = [];
  double? intakeGoal;
  double? totalIntake;
  DateTime? _lastFetchedDate;

  void scheduleMidnightRefresh() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = tomorrow.difference(now);

    Future.delayed(durationUntilMidnight, () {
      _loadMeals();
      scheduleMidnightRefresh(); // Reschedule for next day
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMeals();
    getDailyGoal();
    scheduleMidnightRefresh();
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _foodDescriptionController.dispose();
    _foodCaloriesController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _loadMeals() async {
    DateTime today = DateTime.now();
    if (_lastFetchedDate != null && _lastFetchedDate!.day == today.day &&
        _lastFetchedDate!.month == today.month && _lastFetchedDate!.year == today.year) {
      return; // Already loaded for today
    }

    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("Failed to get User ID");

    List<Meal> meals = await ApiService.getMealsForCurrentUser(userId);

    // 🔥 PRINT EVERYTHING
    for (var meal in meals) {
      print('MealID: ${meal.id}, Date: ${meal.date.toLocal()}, Raw Date: ${meal.date}');
    }

    // Now filter
    meals = meals.where((meal) {
      final localDate = meal.date.toLocal(); // 🔥 Important!
      return localDate.day == today.day &&
            localDate.month == today.month &&
            localDate.year == today.year;
    }).toList();

    setState(() {
      _userMeals = meals;
      totalIntake = getTotalCalories(_userMeals);
      _lastFetchedDate = today;
    });
  }

  // create new food
  void createNewFood() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          children: [
            TextField(
              controller: _foodNameController,
              decoration: const InputDecoration(
                hintText: 'Name of the new meal',
              ),
            ),
            TextField(
              controller: _foodDescriptionController,
              decoration: const InputDecoration(
                hintText: 'Short description',
              ),
            ),
            TextField(
              controller: _foodCaloriesController,
              decoration: const InputDecoration(
                hintText: 'Number of calories',
              ),
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () async {
              // get the new food name & calories
              String newFoodName = _foodNameController.text;
              String newFoodDescription = _foodDescriptionController.text;
              double newFoodCalories = double.parse(_foodCaloriesController.text);

              // save to db
              try {
                final mealId = await api.addMeal(newFoodName, newFoodDescription, newFoodCalories);

                print("Meal ID after insertion: $mealId");

                if (mealId != null) {
                  setState(() {
                    totalIntake = getTotalCalories(_userMeals);
                  });
                  print('✅Meal added successfully!');
                  showSuccess('Meal logged!');
                } else {
                  print('❌Failed to log meal');
                  showError('Failed to log meal!');
                }
              } catch(e) {
                print('❌Failed to add new meal: $e');
                showError(e.toString());
              }
              
              // pop box
              Navigator.pop(context);

              // clear controllers
              _foodNameController.clear();
              _foodDescriptionController.clear();
              _foodCaloriesController.clear();
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controllers
              _foodNameController.clear();
              _foodDescriptionController.clear();
              _foodCaloriesController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Set the daily goal
  void setDailyGoal() async {
    final goal = double.tryParse(_caloriesController.text);
    if (goal != null) {
      bool ok = await api.upsertCaloriesGoals(intakeGoal: goal);
      if (ok) {
        setState(() {
          intakeGoal = goal;
        });
        showSuccess('Intake goal updated!');
      } else {
        showError("Failed to update intake goal!");
      }
    }
    _caloriesController.clear();
  }

  // get current daily goal
  void getDailyGoal() async {
    CaloriesGoals caloriesGoals = await api.getCaloriesGoalsForCurrentUser();
    setState(() {
      intakeGoal = caloriesGoals.intakeGoal;
    });
  }

  double getTotalCalories(List<Meal> meals) {
    return meals.fold(0, (total, meal) => total + (meal.calories));
  }

  // edit food box
  void editFoodBox(Meal meal) {
    // set the controller's text to the food's current name & calories
    _foodNameController.text = meal.name;
    _foodDescriptionController.text = meal.description ?? "";
    _foodCaloriesController.text = meal.calories.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          children: [
            TextField(
              controller: _foodNameController,
            ),
            TextField(
              controller: _foodDescriptionController,
            ),
            TextField(
              controller: _foodCaloriesController,
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () async {
              // get the new food name
              String newFoodName = _foodNameController.text;
              String newFoodDescription = _foodDescriptionController.text;
              double newFoodCalories = double.parse(_foodCaloriesController.text);

              // save to db
              try {
                bool ok = await api.updateMeal(meal.id, newFoodName, newFoodDescription, newFoodCalories);
                print(ok);
                if (ok) {
                  setState(() {
                    totalIntake = getTotalCalories(_userMeals);
                  });
                  print('✅Meal updated successfully!');
                  showSuccess('Meal updated!');
                } else {
                  print('❌Failed to update meal!');
                  showError('Failed to update meal!');
                }
              } catch (e) {
                print('❌Failed to add new meal: $e');
                showError(e.toString());
              }
              
              // pop box
              Navigator.pop(context);

              // clear controllers
              _foodNameController.clear();
              _foodDescriptionController.clear();
              _foodCaloriesController.clear();
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controllers
              _foodNameController.clear();
              _foodDescriptionController.clear();
              _foodCaloriesController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      )
    );
  }

  // delete food box
  void deleteFoodBox(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          // delete button
          MaterialButton(
            onPressed: () async {
              // delete from db
              try {
                bool ok = await api.deleteMeal(id);
                if (ok) {
                  setState(() {
                    totalIntake = getTotalCalories(_userMeals);
                  });
                  showSuccess('Meal deleted!');
                } else {
                  showError('Failed to delete meal!');
                }
              } catch (e) {
                showError(e.toString());
              }

              // pop box
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(context);
  }

  Widget _buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNewFood,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Food Page',
                    style: GoogleFonts.dmSerifText(
                      fontSize: 48,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Daily Goal Input Card
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller: _caloriesController,
                                  hintText: 'Daily intake goal',
                                  obscureText: false,
                                ),
                              ),
                              const SizedBox(width: 10),
                              CustomButton(
                                color: Theme.of(context).colorScheme.tertiary,
                                textColor: Theme.of(context).colorScheme.outline,
                                onPressed: setDailyGoal,
                                label: 'Confirm',
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Goal Info Card
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildInfoRow('Calories to reach today:', intakeGoal == null ? 'No goal set' : intakeGoal.toString()),
                              const SizedBox(height: 10),
                              _buildInfoRow('Total intake until now:', totalIntake == null ? 'No intake yet' : totalIntake!.toStringAsFixed(1)),
                              const SizedBox(height: 10),

                              // Progress with percentage and marker
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0), // Extra padding vertically
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final goal = intakeGoal ?? 0;
                                    final intake = totalIntake;
                                    final progress = (goal == 0) ? 0.0 : ((intake ?? 0) / goal).clamp(0.0, 1.0);
                                    final percentage = (progress * 100).toInt();

                                    return SizedBox(
                                      height: 60, // <-- Give enough height for the % and dot
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          // Background bar
                                          Positioned(
                                            top: 30, // Move it down to leave space above
                                            child: Container(
                                              height: 20,
                                              width: constraints.maxWidth,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),

                                          // Gradient bar
                                          Positioned(
                                            top: 30,
                                            child: Container(
                                              height: 20,
                                              width: constraints.maxWidth * progress,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: const LinearGradient(
                                                  colors: [Colors.red, Colors.orange, Colors.green],
                                                  stops: [0.0, 0.5, 1.0],
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Floating percentage + dot
                                          Positioned(
                                            left: (constraints.maxWidth * progress).clamp(0, constraints.maxWidth - 50),
                                            top: 0,
                                            child: Transform.translate(
                                              offset: const Offset(-20, 0), // Adjust this based on the width of your column
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(4),
                                                      boxShadow: const [
                                                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                                                      ],
                                                    ),
                                                    child: Text(
                                                      '$percentage%',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Remaining: ',
                                    style: GoogleFonts.dmSerifText(
                                      fontSize: 24,
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      final caloriesRemaining = (intakeGoal ?? 0) - (totalIntake ?? 0);
                                      return Text(
                                        caloriesRemaining <= 0
                                            ? 'Done for today'
                                            : caloriesRemaining.toString(),
                                        style: GoogleFonts.dmSerifText(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 20),
        
                  Text(
                    'My meals today:',
                    style: GoogleFonts.dmSerifText(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
            ),
            _buildFoodList(),
          ],
        ),
      ),
    );
  }

  /// Helper Widget
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.dmSerifText(
              fontSize: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSerifText(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodList() {
    return _userMeals.isEmpty
        ? const Center(child: Text("No meals logged yet."))
        : ListView.builder(
            shrinkWrap: true, // important when nested
            physics: const NeverScrollableScrollPhysics(), // prevents nested scrolling
            itemCount: _userMeals.length,
            itemBuilder: (context, index) {
              Meal meal = _userMeals[index];
              return FoodTile(
                meal: meal,
                deleteMeal: (context) => deleteFoodBox(meal.id),
                editMeal: (context) => editFoodBox(meal),
              );
            },
          );
  }
}