import 'package:fitness_app/pages/workout_schedule_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/models/workout_schedule_models.dart';
import 'package:fitness_app/services/workout_schedule_service.dart';

class WorkoutScheduleDayPage extends StatefulWidget {
  final WorkoutScheduleDay day;

  const WorkoutScheduleDayPage({super.key, required this.day});

  @override
  State<WorkoutScheduleDayPage> createState() => _WorkoutScheduleDayPageState();
}

class _WorkoutScheduleDayPageState extends State<WorkoutScheduleDayPage> {
  late WorkoutScheduleDay _day;

  @override
  void initState() {
    super.initState();
    _day = widget.day;
  }

  Future<void> _refresh() async {
    final updated = await WorkoutScheduleService.getDay(_day.workoutScheduleDayID);
    setState(() => _day = updated);
  }

  Future<void> showWorkoutDialog({
    required BuildContext context,
    PlannedWorkout? existingWorkout,
    required void Function(PlannedWorkoutInput) onSave,
    required int workoutScheduleDayID,
  }) async {
    final nameController = TextEditingController(text: existingWorkout?.name ?? '');
    final descController = TextEditingController(text: existingWorkout?.description ?? '');
    final setsController = TextEditingController(text: existingWorkout?.sets.toString() ?? '');
    final repsController = TextEditingController(text: existingWorkout?.reps.toString() ?? '');
    String selectedMuscle = existingWorkout?.targetMuscle ?? "Full Chest";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingWorkout == null ? "Add Exercise" : "Edit Exercise"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
              TextField(controller: setsController, decoration: const InputDecoration(labelText: "Sets"), keyboardType: TextInputType.number),
              TextField(controller: repsController, decoration: const InputDecoration(labelText: "Reps"), keyboardType: TextInputType.number),
              DropdownButtonFormField<String>(
                value: selectedMuscle,
                items: ["Full Chest", "Upper Chest", "Middle Chest", "Lower Chest",
                "Upper Back", "Lower Back", "Legs", "Glutes", "Quads", "Calves",
                "Biceps", "Triceps", "Shoulders", "Front Delts", "Side Delts", "Rear Delts",
                "Traps", "Upper Traps", "Full Abs", "Lower Abs", "Middle Abs", "Upper Abs"]
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (val) => selectedMuscle = val ?? "Full Chest",
                decoration: const InputDecoration(labelText: "Target Muscle"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final request = PlannedWorkoutInput(
                workoutScheduleDayID: workoutScheduleDayID,
                name: nameController.text,
                description: descController.text,
                targetMuscle: selectedMuscle,
                sets: int.tryParse(setsController.text) ?? 0,
                reps: int.tryParse(repsController.text) ?? 0,
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

  void _editWorkout(PlannedWorkout workout) async {
    await showWorkoutDialog(
      context: context,
      existingWorkout: workout,
      workoutScheduleDayID: _day.workoutScheduleDayID,
      onSave: (updated) async {
        await WorkoutScheduleService.updateWorkout(workout.plannedWorkoutID!, updated);
        await _refresh();
      },
    );
  }

  void _deleteWorkout(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Exercise"),
        content: const Text("Are you sure you want to delete this exercise?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      await WorkoutScheduleService.deleteWorkout(id);
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekday = WorkoutScheduleDetailPage.weekdays[_day.dayOfWeek];

    return Scaffold(
      appBar: AppBar(title: Text("Day: $weekday")),
      body: ListView.builder(
        itemCount: _day.plannedWorkouts.length,
        itemBuilder: (context, index) {
          final workout = _day.plannedWorkouts[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text("Exercise ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${workout.name}"),
                  if (workout.targetMuscle != null) Text("Target: ${workout.targetMuscle}"),
                  if (workout.sets > 0 && workout.reps > 0) Text("Sets: ${workout.sets}, Reps: ${workout.reps}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editWorkout(workout),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteWorkout(workout.plannedWorkoutID!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _day.isRestDay
    ? null
    : FloatingActionButton(
        onPressed: () {
          showWorkoutDialog(
            context: context,
            workoutScheduleDayID: _day.workoutScheduleDayID,
            onSave: (newWorkout) async {
              await WorkoutScheduleService.addWorkoutToDay(_day.workoutScheduleDayID, newWorkout);
              await _refresh();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
