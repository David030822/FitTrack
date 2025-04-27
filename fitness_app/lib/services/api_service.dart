import 'package:fitness_app/models/calories_goals.dart';
import 'package:fitness_app/models/meal.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = BASE_URL;  // 1
  // static const String baseUrl = BASE_URL;  // 2
  static Future<User?> getUserData(int userId, String token) async {
    final url = Uri.parse('$baseUrl/api/users/$userId');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    debugPrint("API Response: ${response.body}"); // <-- PRINT RESPONSE

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data); // <-- ERROR OCCURS HERE
    } else {
      debugPrint("Failed to fetch user data: ${response.statusCode}");
      return null;
    }
  }

  static Future<bool> updateUserData(int userId, Map<String, dynamic> updatedUser, String token) async {
    var url = Uri.parse('$baseUrl/api/users/$userId');
    var response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(updatedUser),
    );

    return response.statusCode == 204;
  }

  static Future<List<User>> searchUsers(String query) async {
    final url = Uri.parse('$baseUrl/api/users/search_users?query=$query');
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("User is not authenticated");
    }
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search users: ${response.statusCode}');
    }
  }

  static Future<void> addFollowing(int userId, int followingId) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/following/$followingId');
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to add following: ${response.statusCode}');
    }
  }

  static Future<List<User>> getFollowing(int userId) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/following');
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch following users: ${response.statusCode}');
    }
  }

  static Future<List<User>> getFollowers(int userId) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/followers');
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch followers: ${response.body}");
    }
  }

  static Future<void> deleteFollowing(int userId, int followingId) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/following/$followingId');
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete following: ${response.statusCode}');
    }
  }

  static Future<bool> isFollowing(int userId, int targetUserId) async {
    final url = Uri.parse('$baseUrl/api/users/following/$userId/$targetUserId');
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("User is not logged in");
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return response.body == 'true';
    } else {
      throw Exception(
          'Failed to check following status: ${response.statusCode}');
    }
  }

  Future<int?> startWorkout(int categoryId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      return null;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/workouts/create?userId=$userId&categoryId=$categoryId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );

    print(response.body);

    if (response.statusCode == 400 || response.statusCode == 409) {
      final decoded = jsonDecode(response.body);
      throw Exception(decoded['error'] ?? 'Could not start workout.');
    }

    if (response.statusCode == 201) {
      print('🔥 Response body: ${response.body}');

      try {
        final data = jsonDecode(response.body);
        final workout = Workout.fromJson(data);
        print('✅ Workout started! ID: ${workout.id}');
        return workout.id;
      } catch (e) {
        print('🔥 Failed to decode workout: $e');
        print('🧾 Raw response: ${response.body}');
        return null; // <- critical
      }
    } else {
      print('Failed to start workout: ${response.body}');
      return null;
    }
  }

  Future<bool> finishWorkout({
    required int workoutId,
    required double distance,
    required double caloriesBurned,
    required String duration,
    required String avgPace
  }) async {
    print("⚙️ Sending finishWorkout request...");
    final body = jsonEncode({
      'newCalories': caloriesBurned,
      'distance': distance,
      'duration': duration,
      'avgPace': avgPace,
    });
    print("Sending to backend: $body");

    final response = await http.put(
      Uri.parse('$baseUrl/api/workouts/$workoutId/update-calories'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      print("✅Workout updated successfully");
      return true;
    } else {
      print("❌Failed to update workout: ${response.body}");
      return false;
    }
  }

  Future<bool> updateWorkout(int workoutId, double distance) async {
    final url = Uri.parse('$baseUrl/api/workouts/update/$workoutId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "distance": distance 
      }),
    );

    if (response.statusCode == 204) {
      print('✅ Workout updated successfully.');
      return true;
    } else if (response.statusCode == 404) {
      print('❌ Workout not found.');
      return false;
    } else {
      print('❌ Failed to update workout: ${response.body}');
      return false;
    }
  }

  Future<bool> deleteWorkout(int workoutId) async {
    final url = Uri.parse('$baseUrl/api/workouts/delete/$workoutId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 204) {
      print('🗑️ Workout deleted successfully.');
      return true;
    } else if (response.statusCode == 404) {
      print('❌ Workout not found.');
      return false;
    } else {
      print('❌ Failed to delete workout: ${response.body}');
      return false;
    }
  }

  static Future<List<Workout>> getWorkoutsForCurrentUser(int userId) async {
    final url = Uri.parse('$baseUrl/api/workouts/user/$userId'); // adjust this if needed

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      // Convert JSON list to List<Workout>
      return jsonData.map((json) => Workout.fromJson(json)).toList();
    } else {
      print('❌ Failed to fetch workouts: ${response.statusCode} - ${response.body}');
      return [];
    }
  }

  // handling meals
  Future<int?> addMeal(String name, String description, double calories) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      return null;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/meals/create?userId=$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "description": description,
        "calories": calories
      }),
    );

    print(response.body);

    if (response.statusCode == 400 || response.statusCode == 409) {
      final decoded = jsonDecode(response.body);
      throw Exception(decoded['error'] ?? 'Could not add new meal.');
    }

    if (response.statusCode == 201) {
      print('🔥 Response body: ${response.body}');

      try {
        final data = jsonDecode(response.body);
        final meal = Meal.fromJson(data);
        print('✅ Meal added! ID: ${meal.id}');
        return meal.id;
      } catch (e) {
        print('🔥 Failed to decode meal: $e');
        print('🧾 Raw response: ${response.body}');
        return null; // <- critical
      }
    } else {
      print('Failed to add meal: ${response.body}');
      return null;
    }
  }

  static Future<List<Meal>> getMealsForCurrentUser(int userId) async {
    final url = Uri.parse('$baseUrl/api/meals/user/$userId');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    print("🧾RAW meal JSON: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      // Convert JSON list to List<Meal>
      return jsonData.map((json) => Meal.fromJson(json)).toList();
    } else {
      print('❌ Failed to fetch meals: ${response.statusCode} - ${response.body}');
      return [];
    }
  }

  Future<bool> updateMeal(int id, String name, String description, double calories) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      print('❌User ID is NULL!');
      return false;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/api/meals/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "description": description,
        "calories": calories
      }),
    );

    print(response.body);

    if (response.statusCode == 400 || response.statusCode == 409) {
      final decoded = jsonDecode(response.body);
      print(decoded['error'] ?? 'Could not update meal.');
      return false;
    }

    if (response.statusCode == 204) {
      print('✅ Meal updated successfully!');
      return true;
      } else {
      print('❌Failed to update meal!');
      return false;
    }
  }

  Future<bool> deleteMeal(int mealId) async {
    final url = Uri.parse('$baseUrl/api/meals/delete/$mealId');

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 204) {
      print('🗑️ Meal deleted successfully.');
      return true;
    } else if (response.statusCode == 404) {
      print('❌ Meal not found.');
      return false;
    } else {
      print('❌ Failed to delete meal: ${response.body}');
      return false;
    }
  }

  Future<bool> upsertCaloriesGoals({
    double? intakeGoal,
    double? burnGoal,
    double? overallGoal,
    int? intakeStreak,
    int? burnStreak,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      print('❌User ID is NULL!');
      return false;
    }

    final url = Uri.parse('$baseUrl/api/calories-goals/upsert?userId=$userId');

    // Only include non-null values in the body
    final Map<String, dynamic> body = {};
    if (intakeGoal != null) body["intakeGoal"] = intakeGoal;
    if (burnGoal != null) body["burnGoal"] = burnGoal;
    if (overallGoal != null) body["overallGoal"] = overallGoal;
    if (intakeStreak != null) body["intakeStreak"] = intakeStreak;
    if (burnStreak != null) body["burnStreak"] = burnStreak;

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('✅ Calories goals updated!');
      return true;
    } else {
      print('❌ Failed to update calories goals: ${response.body}');
      return false;
    }
  }

  Future<CaloriesGoals> getCaloriesGoalsForCurrentUser() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      print('❌User ID is NULL!');
      throw Exception("User ID is NULL!");
    }

    final url = Uri.parse('$baseUrl/api/calories-goals/get?userId=$userId');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return CaloriesGoals.fromJson(jsonData);
    } else {
      print('❌ Failed to fetch calories goal: ${response.statusCode} - ${response.body}');
      throw Exception("Failed to fetch calories goal!");
    }
  }

  Future<double> fetchTodayCaloriesBurned() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      print('❌User ID is NULL!');
      throw Exception("User ID is NULL!");
    }

    final url = Uri.parse('$baseUrl/api/calories-goals/daily-burn?userId=$userId');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print("Total calories burnt: ${response.body}");
      return double.parse(response.body);
    } else {
      throw Exception('Failed to fetch burned calories');
    }
  }

  Future<double> fetchTodayCaloriesIntake() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      print('❌User ID is NULL!');
      throw Exception("User ID is NULL!");
    }

    final url = Uri.parse('$baseUrl/api/calories-goals/daily-intake?userId=$userId');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      print("Total calories intake: ${response.body}");
      return double.parse(response.body);
    } else {
      throw Exception('Failed to fetch calories intake');
    }
  }

  Future<CaloriesGoals> fetchStreaks() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      throw Exception("Failed to get userID from token!");
    }

    final url = Uri.parse('$baseUrl/api/calories-goals/streaks?userId=$userId');

    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CaloriesGoals.fromJson(data); // Assuming you have a model class
    } else {
      throw Exception('Failed to fetch streaks.');
    }
  }
}