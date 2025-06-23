class WorkoutSchedule {
  final int workoutScheduleID;
  final int userID;
  final String title;
  final DateTime createdAt;
  final bool isActive;
  final List<WorkoutScheduleDay> days;

  WorkoutSchedule({
    required this.workoutScheduleID,
    required this.userID,
    required this.title,
    required this.createdAt,
    required this.isActive,
    required this.days,
  });

  factory WorkoutSchedule.fromJson(Map<String, dynamic> json) => WorkoutSchedule(
    workoutScheduleID: json['workoutScheduleID'],
    userID: json['userID'],
    title: json['title'],
    createdAt: DateTime.parse(json['createdAt']),
    isActive: json['isActive'],
    days: (json['days'] as List).map((d) => WorkoutScheduleDay.fromJson(d)).toList(),
  );

  WorkoutSchedule copyWith({
    int? workoutScheduleID,
    int? userID,
    String? title,
    DateTime? createdAt,
    bool? isActive,
    List<WorkoutScheduleDay>? days,
  }) {
    return WorkoutSchedule(
      workoutScheduleID: workoutScheduleID ?? this.workoutScheduleID,
      userID: userID ?? this.userID,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      days: days ?? this.days,
    );
  }
}

class WorkoutScheduleDay {
  final int workoutScheduleDayID;
  final int dayOfWeek;
  final bool isRestDay;
  final String? workoutLabel;
  final String? startTime;
  final List<PlannedWorkout> plannedWorkouts;

  WorkoutScheduleDay({
    required this.workoutScheduleDayID,
    required this.dayOfWeek,
    required this.isRestDay,
    this.workoutLabel,
    this.startTime,
    required this.plannedWorkouts,
  });

  factory WorkoutScheduleDay.fromJson(Map<String, dynamic> json) => WorkoutScheduleDay(
    workoutScheduleDayID: json['workoutScheduleDayID'],
    dayOfWeek: json['dayOfWeek'],
    isRestDay: json['isRestDay'],
    workoutLabel: json['workoutLabel'],
    startTime: json['startTime'],
    plannedWorkouts: (json['plannedWorkouts'] as List).map((e) => PlannedWorkout.fromJson(e)).toList(),
  );

  WorkoutScheduleDay copyWith({
    int? workoutScheduleDayID,
    int? dayOfWeek,
    bool? isRestDay,
    String? workoutLabel,
    String? startTime,
    List<PlannedWorkout>? plannedWorkouts,
  }) {
    return WorkoutScheduleDay(
      workoutScheduleDayID: workoutScheduleDayID ?? this.workoutScheduleDayID,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isRestDay: isRestDay ?? this.isRestDay,
      workoutLabel: workoutLabel ?? this.workoutLabel,
      startTime: startTime ?? this.startTime,
      plannedWorkouts: plannedWorkouts ?? this.plannedWorkouts,
    );
  }
}

class PlannedWorkout {
  final int? plannedWorkoutID;
  // final int workoutScheduleDayID;
  final String name;
  final String? description;
  final String targetMuscle;
  final int sets;
  final int reps;

  PlannedWorkout({
    this.plannedWorkoutID,
    // required this.workoutScheduleDayID,
    required this.name,
    this.description,
    required this.targetMuscle,
    required this.sets,
    required this.reps,
  });

  factory PlannedWorkout.fromJson(Map<String, dynamic> json)
  {
    try {
      return PlannedWorkout(
        plannedWorkoutID: json['plannedWorkoutID'] as int?,
        name: json['name'] ?? '',
        description: json['description'],
        targetMuscle: json['targetMuscle'] ?? '',
        sets: json['sets'] ?? 0,
        reps: json['reps'] ?? 0,
        // workoutScheduleDayID: json['workoutScheduleDayID'],
      );
    } catch (e) {
      print('❌ Failed to parse PlannedWorkout: $e');
      print('🧪 Raw data: $json');
      rethrow;
    }
  }

  PlannedWorkout copyWith({
    int? plannedWorkoutID,
    int? workoutScheduleDayID,
    String? name,
    String? description,
    String? targetMuscle,
    int? sets,
    int? reps,
  }) {
    return PlannedWorkout(
      plannedWorkoutID: plannedWorkoutID ?? this.plannedWorkoutID,
      // workoutScheduleDayID: workoutScheduleDayID ?? this.workoutScheduleDayID,
      name: name ?? this.name,
      description: description ?? this.description,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
    );
  }
}

class PlannedWorkoutInput {
  final int workoutScheduleDayID;
  final String name;
  final String? description;
  final String targetMuscle;
  final int sets;
  final int reps;

  PlannedWorkoutInput({
    required this.workoutScheduleDayID,
    required this.name,
    this.description,
    required this.targetMuscle,
    required this.sets,
    required this.reps,
  });

  Map<String, dynamic> toJson() => {
    'workoutScheduleDayID': workoutScheduleDayID,
    'name': name,
    'description': description,
    'targetMuscle': targetMuscle,
    'sets': sets,
    'reps': reps,
  };
}