class MealPlan {
  final String id;
  final String title;
  final String message;
  final DateTime date;

  MealPlan({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      title: json['title'],
      message: json['advice'],
      date: DateTime.parse(json['createdAt']),
    );
  }
}

class MealPlanRequest {
  final String userInput;
  final String mealType;
  final int numberOfMeals;
  final String dietType;
  final int numberOfDays;
  final int calories;

  MealPlanRequest({
    required this.userInput,
    required this.mealType,
    required this.numberOfMeals,
    required this.dietType,
    required this.numberOfDays,
    required this.calories
  });

  Map<String, dynamic> toJson() => {
    "userInput": userInput,
    "mealType": mealType,
    "numberOfMeals": numberOfMeals,
    "dietType": dietType,
    "numberOfDays": numberOfDays,
    "calories": calories
  };
}