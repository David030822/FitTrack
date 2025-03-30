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
}