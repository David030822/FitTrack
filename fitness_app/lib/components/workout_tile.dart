import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:flutter/material.dart';
import 'package:fitness_app/models/workout.dart';

class WorkoutTile extends StatelessWidget {
  final Workout workout;
  final void Function(BuildContext)? editWorkout;
  final void Function(BuildContext)? deleteWorkout;

  const WorkoutTile({
    super.key,
    required this.workout,
    required this.editWorkout,
    required this.deleteWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // edit option
            SlidableAction(
              onPressed: editWorkout,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(8),
            ),
      
            // delete option
            SlidableAction(
              onPressed: deleteWorkout,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row (category + date)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workout.category, // "Running", "Cycling", etc.
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(workout.startDate!),
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Details row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoTile('Distance', '${workout.distance.toStringAsFixed(2)} km'),
                  _infoTile('Duration', workout.duration ?? 'Not recorded'), // e.g., "00:45:12"
                  _infoTile('Avg Pace', workout.avgPace ?? '-'),  // e.g., "6:15 /km"
                ],
              ),
              
              const SizedBox(height: 8),
      
              // Calories
              Text(
                '${workout.calories.toStringAsFixed(0)} kcal burned',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}