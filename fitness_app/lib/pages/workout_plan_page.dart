import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/models/workout_plan.dart';
import 'package:fitness_app/services/workout_plan_service.dart';
import 'workout_plan_detail_page.dart';

class WorkoutPlanPage extends StatefulWidget {
  const WorkoutPlanPage({super.key});

  @override
  State<WorkoutPlanPage> createState() => _WorkoutPlanPageState();
}

class _WorkoutPlanPageState extends State<WorkoutPlanPage> {
  List<WorkoutPlan> _plans = [];
  bool _isThinking = false;

  void _fetchPlans() async {
    try {
      final data = await WorkoutPlanService.getWorkoutPlans();
      setState(() => _plans = data);
    } catch (e, st) {
      print("❌Failed to fetch workout plans: $e\n$st");
    }
  }

  void _showPlanInputDialog() {
    String userInput = "";
    String selectedWorkoutType = '';
    int numberOfExercises = 0;
    int duration = 0;
    String difficulty = "";
    String exerciseFocus = "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Generate Workout Plan"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (value) => userInput = value,
                decoration: const InputDecoration(hintText: "Your goal or preferences (optional)"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: selectedWorkoutType.isEmpty ? null : selectedWorkoutType,
                  decoration: const InputDecoration(
                    labelText: "Workout Type",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    "Full Body",
                    "Push",
                    "Pull",
                    "Chest",
                    "Back",
                    "Legs",
                    "Arms",
                    "Core",
                    "Cardio",
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedWorkoutType = value;
                      });
                    }
                  },
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => numberOfExercises = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(hintText: "Number of exercises"),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => duration = int.tryParse(value) ?? 0,
                decoration: const InputDecoration(hintText: "Duration (minutes)"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: difficulty.isEmpty ? null : difficulty,
                  decoration: const InputDecoration(
                    labelText: "Difficulty Level",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    "Beginner",
                    "Amateur",
                    "Intermediate",
                    "Advanced",
                    "Semi-pro",
                    "Pro",
                    "Competition",
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        difficulty = value;
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: exerciseFocus.isEmpty ? null : exerciseFocus,
                  decoration: const InputDecoration(
                    labelText: "Focus",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    "Muscle growth",
                    "Strength",
                    "Endurance",
                    "Compound lifts",
                    "Isolation",
                    "Cardio"
                  ]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        exerciseFocus = value;
                      });
                    }
                  },
                ),
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

              final request = WorkoutPlanRequest(
                userInput: userInput,
                workoutType: selectedWorkoutType,
                numberOfExercises: numberOfExercises,
                duration: duration,
                difficulty: difficulty,
                exerciseFocus: exerciseFocus,
              );

              final plan = await WorkoutPlanService.requestWorkoutPlan(request);

              if (plan != null) {
                setState(() => _plans.add(plan));
              }

              _fetchPlans();
              setState(() => _isThinking = false);
            },
            child: const Text("Generate"),
          ),
        ],
      ),
    );
  }

  void _editTitle(BuildContext context, WorkoutPlan plan) async {
    final controller = TextEditingController(text: plan.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Title"),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("Save")),
        ],
      ),
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      final ok = await WorkoutPlanService.updateWorkoutPlanTitle(plan.id, newTitle);
      if (ok) {
        _fetchPlans();
        _showSnack("Title updated!", true);
      } else {
        _showSnack("Failed to update title!", false);
      }
    }
  }

  void _deletePlan(BuildContext context, WorkoutPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Workout Plan"),
        content: const Text("Are you sure you want to delete this plan?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      await WorkoutPlanService.deleteWorkoutPlan(plan.id);
      _fetchPlans();
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
    _fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Workout Plans")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPlanInputDialog,
        icon: const Icon(Icons.fitness_center),
        label: const Text("Get Workout Plan"),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isThinking
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                final plan = _plans[index];
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
                          builder: (_) => WorkoutPlanDetailPage(plan: plan),
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
