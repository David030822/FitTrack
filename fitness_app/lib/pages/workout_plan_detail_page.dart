import 'package:fitness_app/models/workout_plan.dart';
import 'package:flutter/material.dart';

class WorkoutPlanDetailPage extends StatelessWidget {
  final WorkoutPlan plan;

  const WorkoutPlanDetailPage({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plan.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            plan.message,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
