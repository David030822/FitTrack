// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/models/calories_goals.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/util/custom_button.dart';
import 'package:fitness_app/util/my_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final api = ApiService();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  final _scrollController = ScrollController();
  final _caloriesController = TextEditingController();
  double? burnGoal;
  double? totalBurnt;
  int? _currentWorkoutId;
  // DateTime? _startTime;
  int? _selectedCategoryId; // Stores the selected category ID
  bool isLoading = true;
  bool isPaused = false;
  final String baseUrl = BASE_URL;

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
    _scrollController.dispose();
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

  // Set the daily goal
  void setDailyGoal() async {
    final goal = double.tryParse(_caloriesController.text);
    if (goal != null) {
      bool ok = await api.upsertCaloriesGoals(burnGoal: goal);
      if (ok) {
        setState(() {
          burnGoal = goal;
        });
        showSuccess('Burn goal updated!');
      } else {
        showError("Failed to update burn goal!");
      }
    }
    _caloriesController.clear();
  }

  // get current daily goal
  void getDailyGoal() async {
    CaloriesGoals caloriesGoals = await api.getCaloriesGoalsForCurrentUser();
    setState(() {
      burnGoal = caloriesGoals.burnGoal;
    });
  }

  void getTotalCalories() async {
    double total = await api.fetchTodayCaloriesBurned();
    print('🟢 Total Calories Burned: $total');
    setState(() {
      totalBurnt = total;
    });
  }

  @override
  void initState() {
    getDailyGoal();
    getTotalCalories();
    super.initState();
  }

  /// Helper Widget
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.dmSerifText(
              fontSize: 20,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSerifText(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Training Page',
                    style: GoogleFonts.dmSerifText(
                      fontSize: 48,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
            
                  const SizedBox(height: 25),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Daily Goal Input Card
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: MyTextField(
                                  controller: _caloriesController,
                                  hintText: 'Daily burn goal',
                                  obscureText: false,
                                ),
                              ),
                              const SizedBox(width: 10),
                              CustomButton(
                                color: Theme.of(context).colorScheme.tertiary,
                                textColor: Theme.of(context).colorScheme.outline,
                                onPressed: setDailyGoal,
                                label: 'Confirm',
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                      // Goal Info Card
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildInfoRow('Calories to burn today:', burnGoal == null ? 'No goal set' : burnGoal.toString()),
                              const SizedBox(height: 10),
                              _buildInfoRow('Total burnt until now:', totalBurnt == null ? 'No calories burnt yet' : totalBurnt!.toStringAsFixed(1)),
                              const SizedBox(height: 10),

                              // Progress with percentage and marker
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0), // Extra padding vertically
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final goal = burnGoal ?? 0;
                                    final intake = totalBurnt;
                                    final progress = (goal == 0) ? 0.0 : ((intake ?? 0) / goal).clamp(0.0, 1.0);
                                    final percentage = (progress * 100).toInt();

                                    return SizedBox(
                                      height: 60, // <-- Give enough height for the % and dot
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          // Background bar
                                          Positioned(
                                            top: 30, // Move it down to leave space above
                                            child: Container(
                                              height: 20,
                                              width: constraints.maxWidth,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),

                                          // Gradient bar
                                          Positioned(
                                            top: 30,
                                            child: Container(
                                              height: 20,
                                              width: constraints.maxWidth * progress,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: const LinearGradient(
                                                  colors: [Colors.red, Colors.orange, Colors.green],
                                                  stops: [0.0, 0.5, 1.0],
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Floating percentage + dot
                                          Positioned(
                                            left: (constraints.maxWidth * progress).clamp(0, constraints.maxWidth - 50),
                                            top: 0,
                                            child: Transform.translate(
                                              offset: const Offset(-20, 0), // Adjust this based on the width of your column
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(4),
                                                      boxShadow: const [
                                                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                                                      ],
                                                    ),
                                                    child: Text(
                                                      '$percentage%',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Remaining: ',
                                    style: GoogleFonts.dmSerifText(
                                      fontSize: 24,
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      final caloriesRemaining = (burnGoal ?? 0) - (totalBurnt ?? 0);
                                      return Text(
                                        caloriesRemaining <= 0
                                            ? 'Done for today'
                                            : caloriesRemaining.toStringAsFixed(1),
                                        style: GoogleFonts.dmSerifText(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 20),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Start a new workout',
                            style: GoogleFonts.dmSerifText(
                              fontSize: 36,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Type',
                                style: GoogleFonts.dmSerifText(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                              ),
            
                              SizedBox(width: 15),
            
                              MyDropdownButton(
                                onCategorySelected: (int selectedId) {
                                  setState(() {
                                    _selectedCategoryId = selectedId;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
            
                      const SizedBox(height: 50),
            
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<int>(
                            stream: _stopWatchTimer.rawTime,
                            initialData: _stopWatchTimer.rawTime.value,
                            builder: (context, snapshot){
                              final value = snapshot.data;
                              final displayTime = StopWatchTimer.getDisplayTime(value!, hours: _isHours);
                              return Text(
                                displayTime,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                      
                          const SizedBox(height: 10),
                      
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // start button
                              CustomButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                onPressed: () async {
                                  print("Current workout ID: $_currentWorkoutId");
                                  // bool isWorkoutInProgress() =>
                                  //   _currentWorkoutId != null && _currentWorkoutId != 0;
                                  // if (isWorkoutInProgress()) {
                                  //   // Already started, don't allow
                                  //   print("Workout already in progress.");
                                  //   showError("Workout already in progress!");
                                  //   return;
                                  // }
                                  try {
                                    _stopWatchTimer.onStartTimer();
                                    final categoryId = _selectedCategoryId;
                                    if (categoryId == null) {
                                      showError("Please select a category.");
                                      return;
                                    }
                                    final api = ApiService();
                                    final workoutId = await api.startWorkout(categoryId);

                                    print("Workout ID after start: $workoutId");

                                    if (workoutId != null) {
                                      setState(() {
                                        _currentWorkoutId = workoutId;
                                        // _startTime = DateTime.now();
                                      });
                                      print("🔥 Workout started with ID: $_currentWorkoutId");
                                    } else {
                                      showError("Failed to start workout.");
                                    }
                                  } catch (e) {
                                    print('❌Failed to start workout: $e');
                                    showError(e.toString());
                                  }
                                },
                                label: 'Start',
                              ),
                      
                              const SizedBox(width: 10),
                      
                              // stop
                              CustomButton(
                                color: Colors.red,
                                textColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    isPaused = !isPaused;
                                  });
                                  if (isPaused) {
                                    _stopWatchTimer.onStopTimer();
                                  }
                                  else {
                                    _stopWatchTimer.onStartTimer();
                                  }
                                },
                                label: isPaused ? 'Resume' : 'Pause',
                              ),
                            ],
                          ),
                      
                          const SizedBox(height: 10),
                      
                          // lap
                          CustomButton(
                            color: Color(0xFFF15C2A),
                            textColor: Colors.white,
                            onPressed: () {
                              _stopWatchTimer.onAddLap();
                            },
                            label: 'Lap',
                          ),
                      
                          const SizedBox(height: 10),
                      
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // reset
                              CustomButton(
                                color: Colors.black,
                                textColor: Colors.white,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Are you sure you want to reset? All data will be lost.'),
                                      actions: [
                                        // confirm button
                                        MaterialButton(
                                          onPressed: () async {
                                            final api = ApiService();
                                            if (_currentWorkoutId != null) {
                                              bool ok = await api.deleteWorkout(_currentWorkoutId!);
                                              if (ok) {
                                                print("✅Deleted workout with ID: $_currentWorkoutId successfully!");
                                                showSuccess('Workout data reset!');
                                              } else {
                                                print('❌Failed to delete workout!');
                                                showError('Failed to reset workout!');
                                              }
                                              
                                              if (mounted) {
                                                setState(() {
                                                  _currentWorkoutId = null;
                                                  // _startTime = null;
                                                });
                                              }

                                              // reset stopwatch
                                              _stopWatchTimer.onResetTimer();

                                              // pop box
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text('Yes'),
                                        ),
                              
                                        // cancel button
                                        MaterialButton(
                                          onPressed: () {
                                            // pop box
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    )
                                  );
                                },
                                label: 'Reset',
                              ),
            
                              const SizedBox(width: 10),
            
                              // save
                              CustomButton(
                                color: Colors.white,
                                textColor: Colors.black,
                                onPressed: () {
                                  // print("🟢 Save button pressed");
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Finish and save?'),
                                      actions: [
                                        // confirm button
                                        MaterialButton(
                                          onPressed: () async {
                                            // print("🔵 YES BUTTON TAPPED");
                                              // save data to db...
                                              final elapsedSeconds = _stopWatchTimer.secondTime.value;
                                              final caloriesBurned = 0.1 * elapsedSeconds;
                                              final distance = elapsedSeconds * 0.005;

                                              final duration = Duration(seconds: elapsedSeconds);
                                              final formattedDuration = "${duration.inHours.toString().padLeft(2, '0')}:"
                                                                        "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
                                                                        "${(duration.inSeconds % 60).toString().padLeft(2, '0')}";

                                              final distanceKm = distance;
                                              final elapsedMinutes = elapsedSeconds / 60;
                                              final avgPace = distanceKm > 0 ? elapsedMinutes / distanceKm : 0;
                                              final paceMinutes = avgPace.floor();
                                              final paceSeconds = ((avgPace - paceMinutes) * 60).round();
                                              final formattedPace = "${paceMinutes}:${paceSeconds.toString().padLeft(2, '0')} /km";

                                              final api = ApiService();
                                              print("Current workout ID: $_currentWorkoutId");

                                              if (_currentWorkoutId != null) {
                                                print("Sending update for workout ID: $_currentWorkoutId");

                                              try {
                                                final success = await api.finishWorkout(
                                                  workoutId: _currentWorkoutId!,
                                                  distance: distance,
                                                  caloriesBurned: caloriesBurned,
                                                  duration: formattedDuration,
                                                  avgPace: formattedPace,
                                                );

                                                if (success) {
                                                  // reset timer
                                                  _stopWatchTimer.onResetTimer();

                                                  // optionally reset local state
                                                  if (mounted) {
                                                    setState(() {
                                                      _currentWorkoutId = null;
                                                      // _startTime = null;
                                                    });
                                                  }

                                                  Navigator.pop(context);
                                                } else {
                                                  // handle error
                                                  print("❌Failed to update workout");
                                                  Navigator.pop(context);
                                                  showError("❌Failed to update workout");
                                                }
                                              } catch (e, st) {
                                                  print("❌ Exception occurred while finishing workout: $e");
                                                  print("Stacktrace: $st");
                                                  showError("❌ An error occurred. Please try again.");
                                                }
                                              } else {
                                                // handle error
                                                print("❌Workout ID is NULL");
                                                Navigator.pop(context);
                                                showError("❌Failed to get workout ID");
                                              }
                                            },
                                          child: const Text('Yes'),
                                        ),
            
                                        // cancel button
                                        MaterialButton(
                                          onPressed: () {
                                            // pop box
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    )
                                  );
                                },
                                label: 'Save',
                              ),
                            ],
                          ),
                      
                          Container(
                            height: 120,
                            margin: const EdgeInsets.all(8),
                            child: StreamBuilder<List<StopWatchRecord>>(
                              stream: _stopWatchTimer.records,
                              initialData: _stopWatchTimer.records.value,
                              builder: (context, snapshot) {
                                final value = snapshot.data;
                                if (value!.isEmpty) {
                                  return Container();
                                }
                      
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                  );
                                });
                      
                                return ListView.builder(
                                  controller: _scrollController,
                                  itemCount: value.length,
                                  itemBuilder: (context, index) {
                                    final data = value[index];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${index + 1} - ${data.displayTime}',
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // const Divider(height: 1),
                                      ],
                                    );
                                  }
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}