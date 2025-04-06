// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/database/food_database.dart';
import 'package:fitness_app/pages/home_page.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/util/custom_button.dart';
import 'package:fitness_app/util/my_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  final _scrollController = ScrollController();
  final _caloriesController = TextEditingController();
  String _calories = '';
  int? _currentWorkoutId;
  DateTime? _startTime;
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

  @override
  void initState() {
    super.initState();
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
                  
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: _caloriesController,
                            hintText: 'Enter daily goal',
                            obscureText: false,
                          ),
                        ),
                        CustomButton(
                          color: Theme.of(context).colorScheme.tertiary,
                          textColor: Theme.of(context).colorScheme.outline,
                          onPressed: () {
                            setState(() {
                              _calories = _caloriesController.text;
                              final double newGoal = double.tryParse(_calories) ?? 0.0;
            
                              // Save the new goal to the database
                              Provider.of<FoodDatabase>(context, listen: false).updateCaloriesToBurnGoal(newGoal);
            
                              _caloriesController.clear(); // Clear the text field
                            });
                          },
                          label: 'Confirm',
                        ),
                      ],
                    ),
                  ),
            
                  const SizedBox(height: 15),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Calories to burn today: ',
                        style: GoogleFonts.dmSerifText(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Consumer<FoodDatabase>(
                        builder: (context, foodDatabase, child) {
                          final caloriesToBurnGoal = foodDatabase.appSettings.dailyBurnGoal;
                          return Text(
                            caloriesToBurnGoal == 0.0 ? 'No goal set' : caloriesToBurnGoal.toString(),
                            style: GoogleFonts.dmSerifText(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
            
                  SizedBox(height: 20),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Calories burnt until now: ',
                        style: GoogleFonts.dmSerifText(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Consumer<FoodDatabase>(
                        builder: (context, foodDatabase, child) {
                          final caloriesBurnt = foodDatabase.appSettings.totalBurnt;
                          return Text(
                            caloriesBurnt == 0.0 ? 'Zero' : caloriesBurnt.toString(),
                            style: GoogleFonts.dmSerifText(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 10),
            
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
                      Consumer<FoodDatabase>(
                        builder: (context, foodDatabase, child) {
                          final caloriesRemaining = foodDatabase.appSettings.dailyBurnGoal - foodDatabase.appSettings.totalBurnt;
                          return Text(
                            caloriesRemaining == 0.0 ? 'Done for today' : caloriesRemaining.toString(),
                            style: GoogleFonts.dmSerifText(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          );
                        },
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
                                        _startTime = DateTime.now();
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
                                              await api.deleteWorkout(_currentWorkoutId!);
                                              print("✅Deleted workout with ID: $_currentWorkoutId successfully!");

                                              if (mounted) {
                                                setState(() {
                                                  _currentWorkoutId = null;
                                                  _startTime = null;
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
                                              final caloriesBurned = 0.1 * elapsedSeconds; // or use your logic
                                              final distance = elapsedSeconds * 0.005;

                                              final api = ApiService();
                                              print("Current workout ID: $_currentWorkoutId");

                                              if (_currentWorkoutId != null) {
                                                print("Sending update for workout ID: $_currentWorkoutId");

                                              try {
                                                final success = await api.finishWorkout(
                                                  workoutId: _currentWorkoutId!,
                                                  distance: distance,
                                                  caloriesBurned: caloriesBurned,
                                                );

                                                if (success) {
                                                  // reset timer
                                                  _stopWatchTimer.onResetTimer();

                                                  // optionally reset local state
                                                  if (mounted) {
                                                    setState(() {
                                                      _currentWorkoutId = null;
                                                      _startTime = null;
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