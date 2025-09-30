class CaloriesGoals {
  final int caloriesGoalsID;
  final double? intakeGoal;
  final double? burnGoal;
  final int? intakeStreak;
  final int? burnStreak;
  final double? overallGoal;

  CaloriesGoals({
    required this.caloriesGoalsID,
    this.intakeGoal,
    this.burnGoal,
    this.intakeStreak,
    this.burnStreak,
    this.overallGoal,
  });

  factory CaloriesGoals.fromJson(Map<String, dynamic> json) {
    return CaloriesGoals(
      caloriesGoalsID: json['caloriesGoalsID'],
      intakeGoal: (json['intakeGoal'] as num?)?.toDouble(),
      burnGoal: (json['burnGoal'] as num?)?.toDouble(),
      intakeStreak: json['intakeStreak'],
      burnStreak: json['burnStreak'],
      overallGoal: (json['overallGoal'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caloriesGoalsID': caloriesGoalsID,
      'intakeGoal': intakeGoal,
      'burnGoal': burnGoal,
      'intakeStreak': intakeStreak,
      'burnStreak': burnStreak,
      'overallGoal': overallGoal,
    };
  }
}