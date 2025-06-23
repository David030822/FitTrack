import 'dart:convert';

import 'package:fitness_app/models/workout_schedule_models.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class WorkoutScheduleService {
  static const String _baseUrl = "$BASE_URL/schedules/workouts";

  // 🔥 Auth helpers
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<int?> _getUserId() async {
    final token = await AuthService.getToken();
    return token != null ? await AuthService.getUserIdFromToken(token) : null;
  }

  // ✅ Get all schedules for user
  static Future<List<WorkoutSchedule>> getSchedules() async {
    final userId = await _getUserId();
    final url = Uri.parse('$_baseUrl/user/$userId');

    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((json) => WorkoutSchedule.fromJson(json)).toList();
    }
    throw Exception("Failed to fetch schedules");
  }

  // ✅ Get schedule by ID
  static Future<WorkoutSchedule> getScheduleById(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(url, headers: await _getHeaders());
    return WorkoutSchedule.fromJson(jsonDecode(response.body));
  }

  // ✅ Create schedule
  static Future<WorkoutSchedule> createSchedule(String title) async {
    final userId = await _getUserId();
    final url = Uri.parse('$_baseUrl/user/$userId');
    final response = await http.post(url,
      headers: await _getHeaders(),
      body: jsonEncode({'title': title}),
    );
    return WorkoutSchedule.fromJson(jsonDecode(response.body));
  }

  // ✅ Update title
  static Future<void> updateScheduleTitle(int id, String title) async {
    final url = Uri.parse('$_baseUrl/$id/title');
    await http.put(url,
      headers: await _getHeaders(),
      body: jsonEncode({'title': title}),
    );
  }

  // ✅ Delete schedule
  static Future<void> deleteSchedule(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    await http.delete(url, headers: await _getHeaders());
  }

  // ✅ Toggle active
  static Future<void> toggleActive(int scheduleId) async {
    final userId = _getUserId();
    final url = Uri.parse('$_baseUrl/$scheduleId/toggle-active');
    await http.put(url, headers: await _getHeaders());
  }

  // ✅ Get a day
  static Future<WorkoutScheduleDay> getDay(int dayId) async {
    final url = Uri.parse('$_baseUrl/day/$dayId');
    final response = await http.get(url, headers: await _getHeaders());
    return WorkoutScheduleDay.fromJson(jsonDecode(response.body));
  }

  // ✅ Toggle rest day
  static Future<void> toggleRestDay(int dayId) async {
    final url = Uri.parse('$_baseUrl/day/$dayId/toggle-rest');
    await http.put(url, headers: await _getHeaders());
  }

  // ✅ Update day (label/time)
  static Future<void> updateDay(int dayId, String? label, String? startTime) async {
    final url = Uri.parse('$_baseUrl/day/$dayId');
    await http.put(url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'workoutLabel': label,
        'startTime': startTime,
      }),
    );
  }

  // ✅ Get workouts for day
  static Future<List<PlannedWorkout>> getWorkoutsForDay(int dayId) async {
    final url = Uri.parse('$_baseUrl/day/$dayId/workouts');
    final response = await http.get(url, headers: await _getHeaders());
    final list = jsonDecode(response.body) as List;
    return list.map((json) => PlannedWorkout.fromJson(json)).toList();
  }

  // ✅ Add workout
  static Future<void> addWorkoutToDay(int dayId, PlannedWorkoutInput workout) async {
    final url = Uri.parse('$_baseUrl/day/$dayId/exercise');
    await http.post(url,
      headers: await _getHeaders(),
      body: jsonEncode(workout.toJson()),
    );
  }

  // ✅ Update workout
  static Future<void> updateWorkout(int workoutId, PlannedWorkoutInput workout) async {
    final url = Uri.parse('$_baseUrl/exercise/$workoutId');
    await http.put(url,
      headers: await _getHeaders(),
      body: jsonEncode(workout.toJson()),
    );
  }

  // ✅ Delete workout
  static Future<void> deleteWorkout(int workoutId) async {
    final url = Uri.parse('$_baseUrl/exercise/$workoutId');
    await http.delete(url, headers: await _getHeaders());
  }
}