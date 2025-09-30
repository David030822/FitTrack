import 'dart:convert';

import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String _baseUrl = BASE_URL;

  static Future<Map<String, dynamic>?> postWithAuth(
    String path,
    Map<String, dynamic> body,
  ) async {
    final token = await AuthService.getToken();
    final userId = await AuthService.getUserIdFromToken(token ?? "");
    if (token == null || userId == null) throw Exception("Authentication error");

    final url = Uri.parse('$_baseUrl$path');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({...body, 'userId': userId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<bool> putWithAuth(
    String path,
    Map<String, dynamic> body,
  ) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User not logged in");

    final url = Uri.parse('$_baseUrl$path');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteWithAuth(String path) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User not logged in");

    final url = Uri.parse('$_baseUrl$path');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> getWithAuthMap(String path) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User not logged in");

    final url = Uri.parse('$_baseUrl$path');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  static Future<List<dynamic>?> getWithAuthList(String path) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User not logged in");

    final url = Uri.parse('$_baseUrl$path');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded;
      }
    }

    return null;
  }
}