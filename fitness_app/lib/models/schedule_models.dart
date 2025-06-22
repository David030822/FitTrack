class MealSchedule {
  final int mealScheduleID;
  final int userID;
  final String? title;
  final DateTime createdAt;
  final bool isActive;
  final List<MealScheduleDay> days;

  MealSchedule({required this.mealScheduleID, required this.userID, required this.createdAt, this.title, required this.isActive, required this.days});

  factory MealSchedule.fromJson(Map<String, dynamic> json) => MealSchedule(
    mealScheduleID: json['mealScheduleID'],
    userID: json['userID'],
    title: json['title'] ?? 'Title not set',
    createdAt: DateTime.parse(json['createdAt']),
    isActive: json['isActive'] ?? false,
    days: (json['days'] as List).map((d) => MealScheduleDay.fromJson(d)).toList(),
  );
}

class MealScheduleDay {
  final int mealScheduleDayID;
  final int dayOfWeek;
  final bool isCheatDay;
  final List<PlannedMeal> plannedMeals;

  MealScheduleDay({required this.mealScheduleDayID, required this.dayOfWeek, required this.isCheatDay, required this.plannedMeals});

  MealScheduleDay copyWith({
    int? mealScheduleDayID,
    int? dayOfWeek,
    bool? isCheatDay,
    List<PlannedMeal>? plannedMeals,
  }) {
    return MealScheduleDay(
      mealScheduleDayID: mealScheduleDayID ?? this.mealScheduleDayID,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isCheatDay: isCheatDay ?? this.isCheatDay,
      plannedMeals: plannedMeals ?? this.plannedMeals,
    );
  }

  factory MealScheduleDay.fromJson(Map<String, dynamic> json) => MealScheduleDay(
    mealScheduleDayID: json['mealScheduleDayID'],
    dayOfWeek: json['dayOfWeek'],
    isCheatDay: json['isCheatDay'] ?? false,
    plannedMeals: (json['plannedMeals'] as List).map((m) => PlannedMeal.fromJson(m)).toList(),
  );
}

class PlannedMeal {
  final int plannedMealID;
  final String mealType;
  final String name;
  final String? description;
  final int? calories;
  final String time;

  PlannedMeal({required this.plannedMealID, required this.mealType, required this.name, this.description, this.calories, required this.time});

  factory PlannedMeal.fromJson(Map<String, dynamic> json) => PlannedMeal(
    plannedMealID: json['plannedMealID'],
    mealType: json['mealType'],
    name: json['name'],
    description: json['description'],
    calories: json['calories'],
    time: json['time'],
  );
}

class PlannedMealInput {
  final String mealType;
  final String name;
  final String? description;
  final int? calories;
  final String time;
  final int mealScheduleDayID;

  PlannedMealInput({required this.mealType, required this.name, this.description, this.calories, required this.time, required this.mealScheduleDayID});

  Map<String, dynamic> toJson() => {
    'mealType': mealType,
    'name': name,
    'description': description,
    'calories': calories,
    'time': time,
    'mealScheduleDayID': mealScheduleDayID
  };
}

enum MealStatus { Completed, Skipped }

class MealLog {
  final int id;
  final int mealId;
  final DateTime date;
  final MealStatus status;

  MealLog({
    required this.id,
    required this.mealId,
    required this.date,
    required this.status,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['id'],
      mealId: json['mealId'],
      date: DateTime.parse(json['date']),
      status: MealStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == json['status'].toString().toLowerCase(),
      ),
    );
  }
}
