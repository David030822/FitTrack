import 'package:fitness_app/models/workout_schedule_models.dart';
import 'package:fitness_app/pages/workout_schedule_day_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/workout_schedule_service.dart';

class WorkoutScheduleDetailPage extends StatefulWidget {
  final WorkoutSchedule schedule;

  const WorkoutScheduleDetailPage({super.key, required this.schedule});

  static const weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  State<WorkoutScheduleDetailPage> createState() => _WorkoutScheduleDetailPageState();
}

class _WorkoutScheduleDetailPageState extends State<WorkoutScheduleDetailPage> {
  late WorkoutSchedule _schedule;

  @override
  void initState() {
    super.initState();
    _schedule = widget.schedule;
  }

  Future<void> _refresh() async {
    final refreshed = await WorkoutScheduleService.getScheduleById(_schedule.workoutScheduleID);
    setState(() => _schedule = refreshed);
  }

  void _toggleRestDay(WorkoutScheduleDay day) async {
    await WorkoutScheduleService.toggleRestDay(day.workoutScheduleDayID);
    await _refresh();
  }

  TimeOfDay? getParsedTime(String? startTime) {
    if (startTime == null || !startTime.contains(":")) return null;
    final parts = startTime.split(":");
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _editDay(WorkoutScheduleDay day) async {
    String label = day.workoutLabel ?? '';
    final labelController = TextEditingController(text: label);
    TimeOfDay? selectedTime = getParsedTime(day.startTime);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Day Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: "Workout Label"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null) {
                  selectedTime = picked;
                }
              },
              child: Text(selectedTime != null
                  ? "Time: ${selectedTime!.format(context)}"
                  : "Pick Start Time"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await WorkoutScheduleService.updateDay(
                day.workoutScheduleDayID,
                labelController.text,
                selectedTime != null
                    ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"
                    : null,
              );
              await _refresh();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule: ${_schedule.title}")),
      body: ListView.builder(
        itemCount: _schedule.days.length,
        itemBuilder: (context, index) {
          final day = _schedule.days[index];
          final weekdayName = WorkoutScheduleDetailPage.weekdays[day.dayOfWeek];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(weekdayName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: day.isRestDay
                  ? const Text("Rest Day", style: TextStyle(color: Colors.redAccent))
                  : Text(
                  day.startTime != null
                      ? "Workout: ${day.workoutLabel} at ${getParsedTime(day.startTime)?.format(context) ?? ''}"
                      : "Workout: ${day.workoutLabel}",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editDay(day),
                  ),
                  IconButton(
                    icon: Icon(day.isRestDay ? Icons.check_box : Icons.check_box_outline_blank),
                    onPressed: () => _toggleRestDay(day),
                    tooltip: "Toggle Rest Day",
                  ),
                ],
              ),
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutScheduleDayPage(day: day),
                  ),
                );
                if (updated == true) await _refresh();
              },
            ),
          );
        },
      ),
    );
  }
}