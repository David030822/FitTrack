import 'dart:convert';

import 'package:fitness_app/models/schedule_models.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class MealScheduleService {
  static const _baseUrl = BASE_URL;

  static Future<List<MealSchedule>> getSchedules() async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");
    
    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("No userId");

    final url = Uri.parse('$_baseUrl/schedules/meals/user/$userId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => MealSchedule.fromJson(e)).toList();
    }

    throw Exception("Failed to fetch schedules");
  }

  static Future<MealSchedule> getScheduleById(int id) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User not logged in");

    final url = Uri.parse('$_baseUrl/schedules/meals/$id');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return MealSchedule.fromJson(json);
    } else {
      throw Exception("Failed to fetch schedule");
    }
  }

  static Future<MealSchedule?> createSchedule(String title) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("Auth fail");

    final url = Uri.parse('$_baseUrl/schedules/meals/user/$userId');
    final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MealSchedule.fromJson(data);
    }

    return null;
  }

  static Future<void> updateScheduleTitle(int scheduleId, String title) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User not logged in");

    final url = Uri.parse('$_baseUrl/schedules/meals/$scheduleId/title');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': title}),
    );

    if (response.statusCode != 204) {
      throw Exception("Failed to update title");
    }

    print("✅ Title updated!");
  }

  static Future<List<PlannedMeal>> getMealsForDay(int dayId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");

    final url = Uri.parse('$_baseUrl/schedules/meals/day/$dayId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => PlannedMeal.fromJson(e)).toList();
    }

    throw Exception("Failed to get meals");
  }

  static Future<PlannedMeal?> addMealToDay(int dayId, PlannedMealInput input) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("No token");

    final url = Uri.parse('$_baseUrl/schedules/meals/day/$dayId');
    final response = await http.post(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode == 200) {
      return PlannedMeal.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  static Future<void> updateMeal(int mealId, PlannedMealInput input) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("No token");

    final url = Uri.parse('$_baseUrl/schedules/meals/edit/$mealId');
    final response = await http.put(url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception("Failed to update meal");
    }
  }

  static Future<void> deleteMeal(int mealId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");

    final url = Uri.parse('$_baseUrl/schedules/meals/delete/$mealId');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 204) {
      throw Exception("Failed to delete meal");
    }
  }

  static Future<void> deleteSchedule(int scheduleId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");

    final url = Uri.parse('$_baseUrl/schedules/meals/$scheduleId');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 204) {
      throw Exception("Failed to delete schedule");
    }
  }

  static Future<void> setActiveSchedule(int scheduleId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");

    final url = Uri.parse('$_baseUrl/schedules/meals/set-active/$scheduleId');

    await http.put(url, headers: {
      'Authorization': 'Bearer $token',
    });
  }

  static Future<MealScheduleDay> getDay(int dayId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");

    final url = Uri.parse('$_baseUrl/schedules/meals/day/$dayId');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return MealScheduleDay.fromJson(json);
    } else {
      throw Exception("Failed to fetch day");
    }
  }

  static Future<void> toggleCheatDay(int dayId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");

    final url = Uri.parse('$_baseUrl/schedules/meals/day/$dayId/toggle-cheat');

    await http.put(url, headers: {
      'Authorization': 'Bearer $token',
    });

    print('✅ Toggled day status!');
  }

  static Future<void> logMeal(int mealId, MealStatus status) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");

    final url = Uri.parse('$_baseUrl/log/$mealId');

    await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status': status.name, // Ensure enum converts to string
      }),
    );
  }

  static Future<List<MealLog>> getWeeklyLogs(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("Not logged in");
    
    final url = Uri.parse('$_baseUrl/logs/week/$userId');

    final res = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return List<MealLog>.from(data.map((x) => MealLog.fromJson(x)));
    }

    return [];
  }
}