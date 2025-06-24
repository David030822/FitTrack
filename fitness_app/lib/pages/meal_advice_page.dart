import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/models/meal_plan.dart';
import 'package:fitness_app/services/meal_plan_service.dart';
import 'meal_plan_detail_page.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  List<MealPlan> _mealPlans = [];
  bool _isThinking = false;

  void _fetchMealPlans() async {
    try {
      final plans = await MealPlanService.getMealPlans();
      setState(() => _mealPlans = plans);
    } catch (e, st) {
      print("❌Failed to fetch meal plans: $e\n$st");
    }
  }

  void _showMealPlanInputDialog() {
    String userInput = "";
    String mealType = "";
    int numberOfMeals = 0;
    String dietType = "";
    int numberOfDays = 0;
    int calories = 0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Generate Meal Plan"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (value) => userInput = value,
                decoration: const InputDecoration(hintText: "Add your preferences (optional)"),
              ),
              TextField(
                onChanged: (value) => mealType = value,
                decoration: const InputDecoration(hintText: "What kind of diet are you looking for?"),
              ),
              TextField(
                onChanged: (value) => dietType = value,
                decoration: const InputDecoration(hintText: "Diet type (vegan, vegetarian, ...)"),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null) {
                    numberOfMeals = parsed;
                  } else {
                    numberOfMeals = 0;
                  }
                },
                decoration: const InputDecoration(hintText: "How many meals per day?"),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null) {
                    calories = parsed;
                  } else {
                    calories = 0;
                  }
                },
                decoration: const InputDecoration(hintText: "How many calories per day?"),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null) {
                    numberOfDays = parsed;
                  } else {
                    numberOfDays = 0;
                  }
                },
                decoration: const InputDecoration(hintText: "How many days for the plan?"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isThinking = true);

              final request = MealPlanRequest(
                userInput: userInput,
                mealType: mealType,
                numberOfMeals: numberOfMeals,
                dietType: dietType,
                numberOfDays: numberOfDays,
                calories: calories
              );

              final plan = await MealPlanService.getAIPlan(request);

              if (plan != null) {
                setState(() => _mealPlans.add(plan));
              }

              _fetchMealPlans();
              setState(() => _isThinking = false);
            },
            child: const Text("Generate"),
          ),
        ],
      ),
    );
  }

  void _editTitle(BuildContext context, MealPlan plan) async {
    final controller = TextEditingController(text: plan.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Title"),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("Save")),
        ],
      ),
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      final ok = await MealPlanService.updateMealPlanTitle(plan.id, newTitle);
      if (ok) {
        _fetchMealPlans();
        _showSnack("Title updated!", true);
      } else {
        _showSnack("Failed to update title!", false);
      }
    }
  }

  void _deletePlan(BuildContext context, MealPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Meal Plan"),
        content: const Text("Are you sure you want to delete this plan?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      await MealPlanService.deleteMealPlan(plan.id);
      _fetchMealPlans();
    }
  }

  void _showSnack(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: success ? Colors.green : Colors.red),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchMealPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Meal Plans")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMealPlanInputDialog,
        icon: const Icon(Icons.restaurant_menu),
        label: const Text("Get Meal Plan"),
        backgroundColor: Colors.teal,
      ),
      body: _isThinking
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _mealPlans.length,
              itemBuilder: (context, index) {
                final plan = _mealPlans[index];
                return Slidable(
                  key: ValueKey(plan.id),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => _editTitle(context, plan),
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (_) => _deletePlan(context, plan),
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text(plan.title.isEmpty ? "Untitled Plan" : plan.title),
                      subtitle: Text(
                        plan.message.length > 50
                            ? "${plan.message.substring(0, 50)}..."
                            : plan.message,
                      ),
                      trailing: Text(
                        DateFormat('yyyy-MM-dd HH:mm').format(plan.date.toLocal()),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealPlanDetailPage(plan: plan),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
