import 'package:flutter/material.dart';
import '../models/meal_plan.dart';

class MealPlanDetailPage extends StatelessWidget {
  final MealPlan plan;

  const MealPlanDetailPage({super.key, required this.plan});

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
