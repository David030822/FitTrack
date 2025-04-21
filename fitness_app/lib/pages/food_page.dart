import 'package:fitness_app/components/food_tile.dart';
import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/database/food_database.dart';
import 'package:fitness_app/models/meal.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:fitness_app/util/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  Future<void> _fetchData() async {
    await context.read<FoodDatabase>().fetchAppSettings();
    await context.read<FoodDatabase>().readFoods();
  }

  @override
  void initState() {
    _loadMeals();
    _fetchData();
    super.initState();
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
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      throw Exception("Failed to get User ID");
    }

    List<Meal> meals = await ApiService.getMealsForCurrentUser(userId);

    setState(() {
      _userMeals = meals;
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
  void setDailyGoal() {
    setState(() {
      final goal = double.tryParse(_caloriesController.text);
    if (goal != null) {
      context.read<FoodDatabase>().updateDailyGoal(goal);
    }
    _caloriesController.clear();
    });
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
    final foodDatabase = context.watch<FoodDatabase>();

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
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: _caloriesController,
                            hintText: 'Enter desired daily intake',
                            obscureText: false,
                          ),
                        ),
                        CustomButton(
                          color: Theme.of(context).colorScheme.tertiary,
                          textColor: Theme.of(context).colorScheme.outline,
                          onPressed: setDailyGoal,
                          label: 'Confirm',
                        ),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 20),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Calories to reach today: ',
                        style: GoogleFonts.dmSerifText(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Text(
                        foodDatabase.appSettings.dailyIntakeGoal == 0 
                          ? 'No goal set' 
                          : foodDatabase.appSettings.dailyIntakeGoal.toString(),
                        style: GoogleFonts.dmSerifText(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 15),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total intake until now: ',
                        style: GoogleFonts.dmSerifText(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Text(
                        foodDatabase.appSettings.totalIntake.toString(),
                        style: GoogleFonts.dmSerifText(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 15),
        
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
                      Consumer<FoodDatabase>(
                        builder: (context, foodDatabase, child) {
                          final caloriesRemaining = foodDatabase.appSettings.dailyIntakeGoal - foodDatabase.appSettings.totalIntake;
                          return Text(
                            caloriesRemaining == 0
                              ? 'Done for today'
                              : caloriesRemaining.toString(),
                            style: GoogleFonts.dmSerifText(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          );
                        },
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