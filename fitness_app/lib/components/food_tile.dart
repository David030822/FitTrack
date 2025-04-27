import 'package:fitness_app/models/meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class FoodTile extends StatelessWidget {
  final Meal meal;
  final void Function(BuildContext)? editMeal;
  final void Function(BuildContext)? deleteMeal;

  const FoodTile({
    super.key,
    required this.meal,
    required this.editMeal,
    required this.deleteMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: editMeal,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: deleteMeal,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Leading Icon
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.orange.shade100,
                child: const Icon(Icons.restaurant_menu, color: Colors.deepOrange),
              ),
              const SizedBox(width: 16),

              // Name + Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (meal.description != null && meal.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          meal.description!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Date (subtle)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat('MMM d, yyyy').format(meal.date),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Calories (Trailing)
              Text(
                '${meal.calories.toStringAsFixed(0)} kCal',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}