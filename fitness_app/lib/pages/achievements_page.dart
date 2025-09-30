import 'package:fitness_app/components/workout_tile.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/services/api_service.dart' show ApiService;
import 'package:fitness_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sticky_headers/sticky_headers.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  List<Workout> _userWorkouts = [];
  final _distanceController = TextEditingController();
  final api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadWorkouts(); // load data when page starts
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

  Future<void> _loadWorkouts() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      throw Exception("Failed to get User ID");
    }

    List<Workout> workouts = await ApiService.getWorkoutsForCurrentUser(userId);

    setState(() {
      _userWorkouts = workouts;
    });
  }

  void delete(int workoutId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          // delete button
          MaterialButton(
            onPressed: () async {
              // delete from db
              try {
                final apiService = ApiService();
                bool ok = await apiService.deleteWorkout(workoutId);

                if (ok) {
                  showSuccess('Workout deleted!');
                } else {
                  showError('Failed to delete workout!');
                }
              } catch (e) {
                showError(e.toString());
              }

              // pop 
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      )
    );
  }

  void edit(Workout workout) {
    _distanceController.text = workout.distance.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          children: [
            TextField(
              controller: _distanceController,
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () async {
              // get the new workout data
              double distance = double.tryParse(_distanceController.text) ?? 0.0;

              // save to db
              bool ok = await api.updateWorkout(workout.id, distance);

              if (ok) {
                showSuccess("Workout updated!");
              } else {
                showError("Failed to update workout!");
              }

              // pop box
              Navigator.pop(context);

              // clear controllers
              _distanceController.clear();
            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controllers
              _distanceController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      )
    );
  }

  Map<String, List<Workout>> groupWorkoutsByMonth(List<Workout> workouts) {
    Map<String, List<Workout>> groupedWorkouts = {};

    for (var workout in workouts) {
      final date = workout.endDate;
      if (date == null) continue; // Skip if no date

      final localDate = date.toLocal(); // Important if coming from backend UTC
      final monthYearKey = "${_monthName(localDate.month)} ${localDate.year}";

      groupedWorkouts.putIfAbsent(monthYearKey, () => []);
      groupedWorkouts[monthYearKey]!.add(workout);
    }

    // Sort workouts inside each month by descending date
    for (var workoutsList in groupedWorkouts.values) {
      workoutsList.sort((a, b) => b.endDate!.compareTo(a.endDate!));
    }

    return groupedWorkouts;
  }

  // String _monthName(int month) {
  //   const months = [
  //     'January', 'February', 'March', 'April', 'May', 'June',
  //     'July', 'August', 'September', 'October', 'November', 'December'
  //   ];
  //   return months[month - 1];
  // }

  Map<String, List<Workout>> groupWorkoutsByDate(List<Workout> workouts) {
    final Map<String, List<Workout>> grouped = {
      'Today': [],
      'Yesterday': [],
      'Earlier': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var workout in workouts) {
      final endDate = workout.endDate?.toLocal(); // just in case UTC sneaks in

      if (endDate == null) continue; // skip nulls safely

      if (endDate.isAfter(today)) {
        grouped['Today']!.add(workout);
      } else if (endDate.isAfter(yesterday)) {
        grouped['Yesterday']!.add(workout);
      } else {
        grouped['Earlier']!.add(workout);
      }
    }

    // Sort each group by date descending
    for (var group in grouped.values) {
      group.sort((a, b) => b.endDate!.compareTo(a.endDate!));
    }

    return grouped;
  }

  Map<String, Map<String, List<Workout>>> groupWorkoutsHybrid(List<Workout> workouts) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, Map<String, List<Workout>>> groupedWorkouts = {};

    for (var workout in workouts) {
      final date = workout.endDate;
      if (date == null) continue;

      final localDate = date.toLocal();
      final workoutDate = DateTime(localDate.year, localDate.month, localDate.day);
      final monthYearKey = "${_monthName(localDate.month)} ${localDate.year}";

      groupedWorkouts.putIfAbsent(monthYearKey, () => {});

      if (localDate.month == now.month && localDate.year == now.year) {
        // Current month special handling
        if (workoutDate == today) {
          groupedWorkouts[monthYearKey]!.putIfAbsent("Today", () => []);
          groupedWorkouts[monthYearKey]!["Today"]!.add(workout);
        } else if (workoutDate == yesterday) {
          groupedWorkouts[monthYearKey]!.putIfAbsent("Yesterday", () => []);
          groupedWorkouts[monthYearKey]!["Yesterday"]!.add(workout);
        } else {
          groupedWorkouts[monthYearKey]!.putIfAbsent("Earlier", () => []);
          groupedWorkouts[monthYearKey]!["Earlier"]!.add(workout);
        }
      } else {
        // Old months, no Today/Yesterday splitting
        groupedWorkouts[monthYearKey]!.putIfAbsent("All", () => []);
        groupedWorkouts[monthYearKey]!["All"]!.add(workout);
      }
    }

    // Sort inside each group
    for (var monthMap in groupedWorkouts.values) {
      for (var workoutList in monthMap.values) {
        workoutList.sort((a, b) => b.endDate!.compareTo(a.endDate!));
      }
    }

    return groupedWorkouts;
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Color _getMonthColor(String monthName) {
    // Cycle some soft colors based on month
    final colors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.red.shade300,
      Colors.teal.shade300,
    ];
    final hash = monthName.hashCode;
    final colorIndex = hash % colors.length;
    return colors[colorIndex];
  }

  Color _getDaySectionColor(String sectionName) {
    switch (sectionName) {
      case "Today":
        return Colors.lightBlue.shade100;
      case "Yesterday":
        return Colors.lightGreen.shade100;
      case "Earlier":
        return Colors.grey.shade200;
      case "All":
      default:
        return Colors.grey.shade300;
    }
  }

  List<MapEntry<String, List<Workout>>> _getSortedDayEntries(Map<String, List<Workout>> dayGroups, List<String> dayOrder) {
    return dayOrder
        .where((day) => dayGroups.containsKey(day))
        .map((day) => MapEntry(day, dayGroups[day]!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final groupedWorkouts = groupWorkoutsHybrid(_userWorkouts);
    final List<String> dayOrder = ["Today", "Yesterday", "Earlier", "All"];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: Text(
                'Achievements',
                style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Expanded(
            child: _userWorkouts.isEmpty
                ? const Center(child: Text("No workouts yet."))
                : ListView.builder(
                    itemCount: groupedWorkouts.entries.length,
                    itemBuilder: (context, monthIndex) {
                      final monthEntry = groupedWorkouts.entries.toList()[monthIndex];
                      final monthName = monthEntry.key;
                      final dayGroups = monthEntry.value;

                      return StickyHeader(
                        header: Container(
                          width: double.infinity,
                          color: _getMonthColor(monthName),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            monthName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _getSortedDayEntries(dayGroups, dayOrder).map((dayEntry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: _getDaySectionColor(dayEntry.key),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    dayEntry.key,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ...dayEntry.value.map((workout) => WorkoutTile(
                                      workout: workout,
                                      deleteWorkout: (context) => delete(workout.id),
                                      editWorkout: (context) => edit(workout),
                                    )),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}