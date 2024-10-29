import 'package:fitness_app/models/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function(BuildContext)? editFood;
  final void Function(BuildContext)? deleteFood;

  const FoodTile({
    super.key,
    required this.food,
    required this.editFood,
    required this.deleteFood,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // edit option
            SlidableAction(
              onPressed: editFood,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(8),
            ),
      
            // delete option
            SlidableAction(
              onPressed: deleteFood,
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
          child: ListTile(
            title: Text(food.name),
            trailing: Text('${food.calories.toString()} kCal'),
          ),
        ),
      ),
    );
  }
}