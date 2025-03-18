import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import '../models/user.dart';

class ApiService {
  static Future<User?> getUserData(int userId, String token) async {
    var url = Uri.parse('http://192.168.0.142:5082/api/users/$userId');
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token", // Secure API call
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<bool> updateUserData(int userId, Map<String, dynamic> updatedUser, String token) async {
    var url = Uri.parse('http://192.168.0.142:5082/api/users/$userId');
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