import 'package:fitness_app/models/meal_schedule_models.dart';
import 'package:fitness_app/pages/meal_schedule_day_page.dart';
import 'package:fitness_app/services/meal_schedule_service.dart';
import 'package:flutter/material.dart';

class MealScheduleDetailPage extends StatefulWidget {
  final MealSchedule schedule;

  const MealScheduleDetailPage({required this.schedule});

  static const weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  State<MealScheduleDetailPage> createState() => _MealScheduleDetailPageState();
}

class _MealScheduleDetailPageState extends State<MealScheduleDetailPage> {
  late MealSchedule _schedule;

  @override
  void initState() {
    super.initState();
    _schedule = widget.schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.schedule.title ?? 'Title not set')),
      body: ListView.builder(
        itemCount: widget.schedule.days.length,
        itemBuilder: (context, index) {
          final day = widget.schedule.days[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(
                MealScheduleDetailPage.weekdays[day.dayOfWeek],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: day.isCheatDay
                  ? const Text("Cheat Day", style: TextStyle(color: Colors.redAccent))
                  : Text("${day.plannedMeals.length} planned meals"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealScheduleDayPage(day: day),
                  ),
                );
                // final updated = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => MealScheduleDayPage(day: day),
                //   ),
                // );

                // if (updated == true) {
                //   final refreshed = await MealScheduleService.getScheduleById(_schedule.mealScheduleID);
                //   setState(() => _schedule = refreshed);
                // }
              }
            ),
          );
        },
      ),
    );
  }
}
