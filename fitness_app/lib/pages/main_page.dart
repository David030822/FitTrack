// ignore_for_file: prefer_const_constructors, prefer_const_declarations

import 'package:fitness_app/components/my_text_field.dart';
import 'package:fitness_app/components/square_tile.dart';
import 'package:fitness_app/components/streak_icon.dart';
import 'package:fitness_app/models/calories_goals.dart';
import 'package:fitness_app/models/weather_model.dart';
import 'package:fitness_app/pages/training_page.dart';
import 'package:fitness_app/services/api_service.dart';
import 'package:fitness_app/services/weather_service.dart';
import 'package:fitness_app/util/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final api = ApiService();
  // text controller for calories
  final _caloriesController = TextEditingController();
  double? overallGoal;
  double? totalBurnt;
  double? totalIntake;
  int? intakeStreakCount;
  int? burnStreakCount;

  // pedometer
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  // weather api key
  final _weatherService = WeatherService('b0fa52b058d9fc9dbec6426c6851406e');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch(e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/animations/sunny.json'; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/animations/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/animations/rainy.json';
      case 'thunderstorm':
        return 'assets/animations/storm.json';
      case 'clear':
        return 'assets/animations/sunny.json';
      default:
        return 'assets/animations/sunny.json';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _caloriesController.dispose();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }

    return granted;
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // Tell the user that the app won't work
      debugPrint('Nem megy');
      return;
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    (_pedestrianStatusStream.listen(onPedestrianStatusChanged))
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
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
      bool ok = await api.upsertCaloriesGoals(overallGoal: goal);
      if (ok) {
        setState(() {
          overallGoal = goal;
        });
        showSuccess('Overall goal updated!');
      } else {
        showError("Failed to update overall goal!");
      }
    }
    _caloriesController.clear();
  }

  // get current daily goal
  void getDailyGoal() async {
    CaloriesGoals caloriesGoals = await api.getCaloriesGoalsForCurrentUser();
    setState(() {
      overallGoal = caloriesGoals.overallGoal;
    });
  }

  void getTotalCaloriesBurnt() async {
    double total = await api.fetchTodayCaloriesBurned();
    print('🟢 Total Calories Burned: $total');
    setState(() {
      totalBurnt = total;
    });
  }

  void getTotalCaloriesIntake() async {
    double total = await api.fetchTodayCaloriesIntake();
    print('🟢 Total Calories Intake: $total');
    setState(() {
      totalIntake = total;
    });
  }

  void getStreaks() async {
    CaloriesGoals goals = await api.fetchStreaks();
    int intakeStreak = goals.intakeStreak ?? 0;
    int burnStreak = goals.burnStreak ?? 0;

    setState(() {
      intakeStreakCount = intakeStreak;
      burnStreakCount = burnStreak;
    });
  }

  String getProgressText(double? intake, double? burnt) {
    if (intake == null && burnt == null) return 'No progress yet';
    if (intake == null) return 'Burnt: ${burnt!.toStringAsFixed(1)}';
    if (burnt == null) return 'Intake: ${intake.toStringAsFixed(1)}';
    return '${intake.toStringAsFixed(1)} - ${burnt.toStringAsFixed(1)} = ${(intake - burnt).toStringAsFixed(1)}';
  }

   @override
  void initState() {
    super.initState();
    initPlatformState();

    getDailyGoal();
    getTotalCaloriesBurnt();
    getTotalCaloriesIntake();
    getStreaks();

    // fetch weather on startup
    _fetchWeather();
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrainingPage(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SquareTile(
                              imagePath: 'assets/images/applogo_step_b.png',
                              height: 50,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            'Home Page',
                            style: GoogleFonts.dmSerifText(
                              fontSize: 48,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        streakIcon(intakeStreakCount ?? 0, 'intake'),
                        const SizedBox(height: 8),
                        streakIcon(burnStreakCount ?? 0, 'burn'),
                      ],
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
                                  hintText: 'Overall goal',
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
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              _buildInfoRow('Today\'s goal :', overallGoal == null ? 'No goal set' : overallGoal!.toStringAsFixed(1)),
                              const SizedBox(height: 10),
                              _buildInfoRow('Progress:', getProgressText(totalIntake, totalBurnt)),

                              const SizedBox(height: 10),

                              // Progress with percentage and marker
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0), // Extra padding vertically
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final goal = overallGoal ?? 0;
                                    final calories = (totalIntake ?? 0.0) - (totalBurnt ?? 0.0);
                                    final progress = (goal == 0) ? 0.0 : (calories / goal).clamp(0.0, 1.0);
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
                                      final caloriesRemaining = (overallGoal ?? 0) - ((totalIntake ?? 0) - (totalBurnt ?? 0));
                                      return Text(
                                        caloriesRemaining == 0
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // city name
                        Text(
                          _weather?.cityName ?? "Loading city...",
                          style: TextStyle(fontSize: 20),
                        ),

                        // animation
                        Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                        // temperature
                        Text(
                          '${_weather?.temperature.round()}°C',
                          style: TextStyle(fontSize: 20),
                        ),

                        // weather condition
                        Text(
                          _weather?.mainCondition ?? "",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(height: 20),

                // Pedometer Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Steps Taken',
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        _steps,
                        style: const TextStyle(fontSize: 60),
                      ),
                      const Divider(
                        height: 100,
                        thickness: 0,
                        color: Colors.white,
                      ),
                      const Text(
                        'Pedestrian Status',
                        style: TextStyle(fontSize: 30),
                      ),
                      Icon(
                        _status == 'walking'
                            ? Icons.directions_walk
                            : _status == 'stopped'
                                ? Icons.accessibility_new
                                : Icons.error,
                        size: 100,
                      ),
                      Center(
                        child: Text(
                          _status,
                          style: _status == 'walking' || _status == 'stopped'
                              ? const TextStyle(fontSize: 30)
                              : const TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}