import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GoalTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editGoal;
  final void Function(BuildContext)? deleteGoal;

  const GoalTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editGoal,
    required this.deleteGoal,
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
              onPressed: editGoal,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(8),
            ),
      
            // delete option
            SlidableAction(
              onPressed: deleteGoal,
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if(onChanged != null) {
              // toggle completion status
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(text),
              leading: Checkbox(
                value: isCompleted,
                onChanged: onChanged,
                activeColor: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );
  }
}