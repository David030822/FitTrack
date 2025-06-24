// import 'package:fitness_app/services/api_helper.dart';

// class WorkoutPlanService {
//   static Future<WorkoutPlan?> getAIPlan(WorkoutPlanRequest request) async {
//     final data = await ApiHelper.postWithAuth(
//       "/personalizedworkoutplan/personal-workout-plan",
//       request.toJson(),
//     );

//     return data != null ? WorkoutPlan.fromJson(data) : null;
//   }

//   static Future<List<WorkoutPlan>> getAllPlans(int userId) async {
//     final data = await ApiHelper.getWithAuth("/personalizedworkoutplan/$userId/workoutplans");
//     return data != null ? data.map<WorkoutPlan>((e) => WorkoutPlan.fromJson(e)).toList() : [];
//   }
// }
