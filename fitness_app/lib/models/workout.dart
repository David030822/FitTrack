class Workout {
  final int id;
  final String category;
  final double distance;
  final double calories;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? duration;
  final String? avgPace;

  Workout({
    required this.id,
    required this.category,
    required this.distance,
    required this.calories,
    required this.startDate,
    required this.endDate,
    this.duration,
    this.avgPace
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] ?? 0,
      category: json['category'] ?? 'Unknown',
      distance: (json['distance'] ?? 0).toDouble(),
      calories: (json['calories'] ?? 0).toDouble(),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      duration: json['duration'] ?? '00:00:00',
      avgPace: json['avgPace'] ?? '00:00 /km',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'distance': distance,
      'calories': calories,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'duration': duration,
      'avgPace': avgPace,
    };
  }
}
