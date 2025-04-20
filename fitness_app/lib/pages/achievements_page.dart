import 'package:fitness_app/components/workout_tile.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/services/api_service.dart' show ApiService;
import 'package:fitness_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  List<Workout> _userWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts(); // load data when page starts
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
              final apiService = ApiService();
              await apiService.deleteWorkout(workoutId);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Workout deleted ✅")),
              );

              // pop box
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          children: [
            // TextField(
            //   controller: _foodNameController,
            // ),
            // TextField(
            //   controller: _foodCaloriesController,
            // ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: () {
              // get the new workout data

              // save to db

              // pop box
              Navigator.pop(context);

              // clear controllers

            },
            child: const Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controllers

            },
            child: const Text('Cancel'),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    itemCount: _userWorkouts.length,
                    itemBuilder: (context, index) {
                      Workout workout = _userWorkouts[index];
                      return WorkoutTile(
                        workout: workout,
                        deleteWorkout: (context) => delete(workout.id),
                        editWorkout: (context) => edit(workout),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}