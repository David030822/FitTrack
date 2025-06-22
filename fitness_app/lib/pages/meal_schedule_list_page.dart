import 'package:fitness_app/models/schedule_models.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/services/meal_schedule_service.dart';
import 'package:fitness_app/pages/meal_schedule_detail_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MealScheduleListPage extends StatefulWidget {
  @override
  _MealScheduleListPageState createState() => _MealScheduleListPageState();
}

class _MealScheduleListPageState extends State<MealScheduleListPage> {
  List<MealSchedule> _schedules = [];
  bool _loading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  Future<void> _fetchSchedules() async {
    final token = await AuthService.getToken();
    final userId = await AuthService.getUserIdFromToken(token!);
    final schedules = await MealScheduleService.getSchedules();
    setState(() {
      _userId = userId;
      _schedules = schedules;
      _loading = false;
    });
  }

  void _toggleActive(MealSchedule selected) async {
    await MealScheduleService.setActiveSchedule(selected.mealScheduleID);
    await _fetchSchedules();
  }

  Future<void> _createNewSchedule() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Meal Schedule"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = controller.text.trim();
              if (title.isEmpty) return;

              Navigator.pop(context); // Close dialog

              final newSchedule = await MealScheduleService.createSchedule(title);
              if (newSchedule != null) {
                setState(() {
                  _schedules.add(newSchedule);
                });
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _editSchedule(MealSchedule sched) {
    final titleController = TextEditingController(text: sched.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Schedule Title'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "Title"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final newTitle = titleController.text.trim();
              if (newTitle.isEmpty) {
                showError("Title can't be empty");
                return;
              }

              try {
                await MealScheduleService.updateScheduleTitle(sched.mealScheduleID, newTitle);
                Navigator.pop(context); // close dialog
                showSuccess("Title updated!");

                final refreshed = await MealScheduleService.getSchedules();
                setState(() => _schedules = refreshed);
              } catch (e) {
                Navigator.pop(context);
                showError("Failed to update title: $e");
              }
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _deleteSchedule(MealSchedule sched) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete this schedule?'),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await MealScheduleService.deleteSchedule(sched.mealScheduleID);
                Navigator.pop(context); // close dialog
                showSuccess("Schedule deleted!");

                setState(() {
                  _schedules.removeWhere((s) => s.mealScheduleID == sched.mealScheduleID);
                });
              } catch (e) {
                Navigator.pop(context);
                showError("Failed to delete: $e");
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Schedules')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                final sched = _schedules[index];
                return Slidable(
                  key: ValueKey(sched.mealScheduleID),
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
                        onPressed: (_) => _deleteSchedule(sched),
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
                        sched.title ?? 'Title not set',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Created at: ${sched.createdAt.toLocal().toString().split(" ")[0]}'),
                      trailing: CupertinoSwitch(
                        value: sched.isActive,
                        onChanged: (val) => _toggleActive(sched),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealScheduleDetailPage(schedule: sched),
                        ),
                      ),
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
