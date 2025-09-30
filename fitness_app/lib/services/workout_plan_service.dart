import 'dart:convert';

import 'package:fitness_app/models/workout_plan.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class WorkoutPlanService{
  static Future<int?> _getUserId() async {
    final token = await AuthService.getToken();
    return token != null ? await AuthService.getUserIdFromToken(token) : null;
  }

  static Future<List<WorkoutPlan>> getWorkoutPlans() async {
    final token = await AuthService.getToken();
    final userId = await _getUserId();

    final url = Uri.parse('$BASE_URL/chat/$userId/workoutplans');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📥 Raw workout plans: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.map((json) => WorkoutPlan.fromJson(json)).toList();
      } else {
        print('❌ Expected a list but got: ${decoded.runtimeType}');
        throw Exception('Invalid response format');
      }
    } else {
      print('❌ Failed to fetch workout plans: ${response.body}');
      throw Exception('Failed to load workout plans!');
    }
  }

  static Future<WorkoutPlan?> getWorkoutPlanById(String planId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await _getUserId();

    final url = Uri.parse('$BASE_URL/chat/$userId/workoutplan/$planId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📥 Workout plan detail: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return WorkoutPlan.fromJson(decoded);
    } else {
      print('❌ Failed to fetch workout plan: ${response.body}');
      return null;
    }
  }

  static Future<WorkoutPlan?> requestWorkoutPlan(WorkoutPlanRequest request) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await _getUserId();

    // Inject the userId before sending
    final updatedRequest = request.copyWith(userId: userId);

    final url = Uri.parse('$BASE_URL/chat/personal-workout-plan');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedRequest.toJson()),
    );

    print('📤 Workout plan request sent. Response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return WorkoutPlan.fromJson(decoded);
    } else {
      print('❌ Failed to request workout plan: ${response.body}');
      return null;
    }
  }

  static Future<bool> updateWorkoutPlanTitle(String planId, String newTitle) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("User ID is NULL!");

    final url = Uri.parse('$BASE_URL/chat/$userId/workoutplans/$planId/title');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'newTitle': newTitle}),
    );

    print('📤 Update title response: ${response.body}');

    return response.statusCode == 200;
  }

  static Future<bool> deleteWorkoutPlan(String planId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("User ID is NULL!");

    final url = Uri.parse('$BASE_URL/chat/$userId/workoutplans/$planId/delete');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('🗑️ Delete workout plan response: ${response.body}');

    return response.statusCode == 200;
  }
}