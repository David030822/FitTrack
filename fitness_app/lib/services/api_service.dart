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
}