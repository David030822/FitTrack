import 'package:fitness_app/models/workout_schedule_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/workout_schedule_service.dart';
import 'package:fitness_app/pages/workout_schedule_detail_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WorkoutScheduleListPage extends StatefulWidget {
  const WorkoutScheduleListPage({super.key});

  @override
  State<WorkoutScheduleListPage> createState() => _WorkoutScheduleListPageState();
}

class _WorkoutScheduleListPageState extends State<WorkoutScheduleListPage> {
  List<WorkoutSchedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final loaded = await WorkoutScheduleService.getSchedules();
    setState(() => _schedules = loaded);
  }

  void _toggleActive(WorkoutSchedule schedule) async {
    await WorkoutScheduleService.toggleActive(schedule.workoutScheduleID);
    await _loadSchedules();
  }

  void _createNewSchedule() {
    String newTitle = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Workout Schedule"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(labelText: "Title"),
          onChanged: (val) => newTitle = val,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (newTitle.trim().isEmpty) return;
              await WorkoutScheduleService.createSchedule(newTitle.trim());
              await _loadSchedules();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void _editSchedule(WorkoutSchedule sched) {
    String title = sched.title;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Title"),
        content: TextField(
          autofocus: true,
          controller: TextEditingController(text: title),
          onChanged: (val) => title = val,
          decoration: const InputDecoration(labelText: "New Title"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (title.trim().isEmpty) return;
              await WorkoutScheduleService.updateScheduleTitle(sched.workoutScheduleID, title.trim());
              await _loadSchedules();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteSchedule(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Are you sure you want to delete this schedule?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await WorkoutScheduleService.deleteSchedule(id);
              await _loadSchedules();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workout Schedules")),
      body: ListView.builder(
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          final sched = _schedules[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _editSchedule(sched),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (_) => _deleteSchedule(sched.workoutScheduleID),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text(
                  sched.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Created: ${sched.createdAt.toLocal().toString().split(" ")[0]}"),
                trailing: CupertinoSwitch(
                  value: sched.isActive,
                  onChanged: (_) => _toggleActive(sched),
                ),
                onTap: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutScheduleDetailPage(schedule: sched),
                    ),
                  );
                  if (updated == true) await _loadSchedules();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewSchedule,
        child: const Icon(Icons.add),
      ),
    );
  }
}
