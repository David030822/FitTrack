import 'package:intl/intl.dart'; // Import the intl package
import 'package:flutter/material.dart';
import 'package:fitness_app/models/workout.dart';

class WorkoutTile extends StatelessWidget {
  final Workout workout;

  const WorkoutTile({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(workout.category),
      subtitle: Text(
        'Start: ${formatDate(workout.startDate)}\nEnd: ${formatDate(workout.endDate)}',
      ),
      trailing: Text('${workout.distance} km\n${workout.calories} kCal'),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}