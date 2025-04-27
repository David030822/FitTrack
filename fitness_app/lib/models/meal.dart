class Meal {
  final int id;
  final String name;
  final String? description;
  final double calories;
  final DateTime date;

  Meal({
    required this.id,
    required this.name,
    this.description,
    required this.calories,
    required this.date
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    // print("👉Parsing Meal: $json👈"); // debug log
    return Meal(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      calories: (json['calories'] ?? 0).toDouble(),
      date: json['date'] != null
        ? DateTime.parse(json['date'])
        : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'calories': calories,
      'date': date
    };
  }
}