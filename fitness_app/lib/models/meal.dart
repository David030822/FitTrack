class Meal {
  final int id;
  final String name;
  final String? description;
  final double calories;

  Meal({
    required this.id,
    required this.name,
    this.description,
    required this.calories,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      calories: (json['calories'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'calories': calories,
    };
  }
}