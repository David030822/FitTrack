import 'dart:convert';

import 'package:fitness_app/models/meal_plan.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/api_helper.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class MealPlanService {
  static Future<int?> _getUserId() async {
    final token = await AuthService.getToken();
    return token != null ? await AuthService.getUserIdFromToken(token) : null;
  }
  
  static Future<MealPlan?> getAIPlan(MealPlanRequest request) async {
    final data = await ApiHelper.postWithAuth(
      "/chat/personal-meal-plan",
      request.toJson(),
    );

    return data != null ? MealPlan.fromJson(data) : null;
  }

  static Future<List<MealPlan>> getAllPlans() async {
    final userId = _getUserId();
    final data = await ApiHelper.getWithAuthList("/chat/$userId/mealplans");

    print("🧠 Received meal plans raw: $data"); // 🧠 See if it's null or empty

    if (data != null) {
      final plans = data.map<MealPlan>((e) => MealPlan.fromJson(e)).toList();
      print("Parsed ${plans.length} meal plans.");
      return plans;
    }

    return [];
  }

  static Future<List<MealPlan>> getMealPlans() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      print('❌ User ID is NULL!');
      throw Exception("User ID is NULL!");
    }

    final url = Uri.parse('$BASE_URL/chat/$userId/mealplans');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📥 Raw meal plan response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        return decoded.map((json) => MealPlan.fromJson(json)).toList();
      } else {
        print('❌ Expected a list but got: ${decoded.runtimeType}');
        throw Exception('Invalid response format');
      }
    } else {
      print('❌ Failed to fetch meal plans: ${response.body}');
      throw Exception('Failed to load meal plans!');
    }
  }

  static Future<MealPlan?> getMealPlanById(String planId) async {
    final userId = _getUserId();
    final data = await ApiHelper.getWithAuthMap(
      "/chat/$userId/mealplan/$planId",
    );
    return data != null ? MealPlan.fromJson(data) : null;
  }

  static Future<bool> updateMealPlanTitleAbs({
    required String planId,
    required String newTitle,
  }) async {
    final userId = _getUserId();
    return await ApiHelper.putWithAuth(
      "/chat/$userId/mealplans/$planId/title",
      {
        "newTitle": newTitle,
      },
    );
  }

  static Future<bool> updateMealPlanTitle(String mealPlanId, String newTitle) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("User ID is NULL!");

    final uri = Uri.parse("$BASE_URL/chat/$userId/mealplans/$mealPlanId/title");

    try {
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'newTitle': newTitle}),
      );

      if (response.statusCode != 200) {
        print('❌ Server responded with status: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        return false;
      }

      return true;
    } catch (e, stackTrace) {
      print('❌ Exception occurred: $e');
      print('❌ StackTrace: $stackTrace');
      throw Exception('Failed to update meal plan title!');
    }
  }

  static Future<bool> deleteMealPlan(String mealPlanId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("User ID is NULL!");

    final uri = Uri.parse("$BASE_URL/chat/$userId/mealplans/$mealPlanId/delete");

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        print('❌ Server responded with status: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        return false;
      }

      return true;
    } catch (e, stackTrace) {
      print('❌ Exception occurred: $e');
      print('❌ StackTrace: $stackTrace');
      throw Exception('Failed to delete meal plan!');
    }
  }

  static Future<bool> deleteMealPlanAbs(String planId) async {
    final userId = _getUserId();
    return await ApiHelper.deleteWithAuth(
      "/chat/$userId/mealplans/$planId/delete",
    );
  }
}
