class WorkoutPlan {
  final String id;
  final String title;
  final String message;
  final DateTime date;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'],
      title: json['title'],
      message: json['advice'],
      date: DateTime.parse(json['createdAt']),
    );
  }
}

class WorkoutPlanRequest {
  int? userId;
  final String userInput;
  final String workoutType;
  final int numberOfExercises;
  final int duration;
  final String difficulty;
  final String exerciseFocus;

  WorkoutPlanRequest({
    this.userId,
    required this.userInput,
    required this.workoutType,
    required this.numberOfExercises,
    required this.duration,
    required this.difficulty,
    required this.exerciseFocus,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userInput": userInput,
    "workoutType": workoutType,
    "numberOfExercises": numberOfExercises,
    "duration": duration,
    "difficulty": difficulty,
    "exerciseFocus": exerciseFocus,
  };

  // Copy helper
  WorkoutPlanRequest copyWith({
    int? userId,
    String? userInput,
    String? workoutType,
    int? numberOfExercises,
    int? duration,
    String? difficulty,
    String? exerciseFocus,
  }) {
    return WorkoutPlanRequest(
      userId: userId ?? this.userId,
      userInput: userInput ?? this.userInput,
      workoutType: workoutType ?? this.workoutType,
      numberOfExercises: numberOfExercises ?? this.numberOfExercises,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      exerciseFocus: exerciseFocus ?? this.exerciseFocus,
    );
  }
}