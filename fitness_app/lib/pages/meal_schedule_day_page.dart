import 'package:fitness_app/models/meal_schedule_models.dart';
import 'package:fitness_app/services/meal_schedule_service.dart';
import 'package:flutter/material.dart';

class MealScheduleDayPage extends StatefulWidget {
  final MealScheduleDay day;

  MealScheduleDayPage({required this.day});

  @override
  _MealScheduleDayPageState createState() => _MealScheduleDayPageState();
}

class _MealScheduleDayPageState extends State<MealScheduleDayPage> {
  late MealScheduleDay _day;

  static const weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _day = widget.day;
  }

  Future<void> _loadDay() async {
    final updated = await MealScheduleService.getDay(_day.mealScheduleDayID);
    setState(() => _day = updated);
  }

  void _toggleCheatDay() async {
    await MealScheduleService.toggleCheatDay(_day.mealScheduleDayID);
    await _loadDay();
  }

  Future<void> showMealDialog({
    required BuildContext context,
    PlannedMeal? existingMeal,
    required Function(PlannedMealInput request) onSave,
  }) async {
    final nameController = TextEditingController(text: existingMeal?.name ?? '');
    final descriptionController = TextEditingController(text: existingMeal?.description ?? '');
    final caloriesController = TextEditingController(text: existingMeal?.calories?.toString() ?? '');
    String parsedTime = existingMeal?.time ?? 'Unknown time';
    final timeController = TextEditingController(
      text: parsedTime,
    );

    String selectedType = existingMeal?.mealType ?? 'Breakfast';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingMeal == null ? "Add Meal" : "Edit Meal"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (val) => selectedType = val ?? 'Breakfast',
                decoration: const InputDecoration(labelText: "Meal Type"),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: caloriesController,
                decoration: const InputDecoration(labelText: "Calories"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: timeController,
                readOnly: true,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    final now = DateTime.now();
                    final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                    final formatted = TimeOfDay.fromDateTime(dt).format(context); // e.g. "08:30 AM" or "14:00"

                    // ⚠️ Optional: Convert to 24h format if needed
                    final hour = picked.hour.toString().padLeft(2, '0');
                    final minute = picked.minute.toString().padLeft(2, '0');
                    final finalTime = "$hour:$minute";

                    timeController.text = formatted;
                    parsedTime = finalTime; // ← send this to backend
                  }
                },
                decoration: const InputDecoration(labelText: "Time"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {

              final request = PlannedMealInput(
                mealScheduleDayID: widget.day.mealScheduleDayID,
                mealType: selectedType,
                name: nameController.text,
                description: descriptionController.text,
                calories: int.tryParse(caloriesController.text) ?? 0,
                time: parsedTime,
              );

              onSave(request);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMeal(BuildContext context, int mealId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Meal"),
        content: const Text("Are you sure you want to delete this meal?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await MealScheduleService.deleteMeal(mealId);
              final updated = await MealScheduleService.getMealsForDay(_day.mealScheduleDayID);
              setState(() => _day = _day.copyWith(plannedMeals: updated));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(weekdays[_day.dayOfWeek])),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Cheat Day"),
            value: _day.isCheatDay,
            onChanged: (_) => _toggleCheatDay(),
          ),
          Expanded(
            child: _day.isCheatDay
                ? const Center(child: Text("It's a cheat day! No meals planned."))
                : ListView.builder(
                    itemCount: _day.plannedMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _day.plannedMeals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          title: Text("Meal ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Type: ${meal.mealType}"),
                              Text("Name: ${meal.name}"),
                              Text("Time: ${meal.time.substring(0, 5)}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min, // 👈 prevents the row from stretching weirdly
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showMealDialog(
                                    context: context,
                                    existingMeal: meal,
                                    onSave: (mealRequest) async {
                                      await MealScheduleService.updateMeal(meal.plannedMealID, mealRequest);
                                      final updated = await MealScheduleService.getMealsForDay(_day.mealScheduleDayID);
                                      setState(() => _day = _day.copyWith(plannedMeals: updated));
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmDeleteMeal(context, meal.plannedMealID);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _day.isCheatDay
          ? null
          : FloatingActionButton(
              onPressed: () => showMealDialog(
                context: context,
                onSave: (mealRequest) async {
                  await MealScheduleService.addMealToDay(_day.mealScheduleDayID, mealRequest);
                  final updated = await MealScheduleService.getMealsForDay(_day.mealScheduleDayID);
                  setState(() => _day = _day.copyWith(plannedMeals: updated));
                },
              ),
              child: const Icon(Icons.add),
            ),
    );
  }
}