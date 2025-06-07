import 'dart:convert';
import 'package:fitness_app/models/conversation.dart';
import 'package:fitness_app/models/message.dart';
import 'package:fitness_app/responsive/constants.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const _baseUrl = BASE_URL;

  static Future<Conversation> sendMessage(String? convoId, String text) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("User ID is NULL!");

    final uri = Uri.parse("$_baseUrl/chat/send");

    print("✅ Sending to $uri with text: $text");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'conversationId': convoId,
          'message': text,
        }),
      );

      if (response.statusCode != 200) {
        print('❌ Server responded with status: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        throw Exception('Failed to send message');
      }

      final data = jsonDecode(response.body);
      return Conversation.fromJson(data); // 🎯 FULL object
    } catch (e, stackTrace) {
      print('❌ Exception occurred: $e');
      print('❌ StackTrace: $stackTrace');
      throw Exception('Failed to send message');
    }
  }

  static Future<Conversation> getConversation(String conversationId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      print('❌User ID is NULL!');
      throw Exception("User ID is NULL!");
    }

    final response = await http.get(Uri.parse('$_baseUrl/chat/$userId/conversations/$conversationId'));

    if (response.statusCode == 200) {
      return Conversation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load conversation');
    }
  }

  static Future<List<Conversation>> getConversations() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception("User is not logged in");
    }

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) {
      print('❌User ID is NULL!');
      throw Exception("User ID is NULL!");
    }

    final response = await http.get(Uri.parse('$_baseUrl/chat/$userId/conversations'));

    print('📥 Raw response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.map((json) => Conversation.fromJson(json)).toList();
      } else {
        print('❌ Expected a list but got: ${decoded.runtimeType}');
        throw Exception('Invalid response format');
      }
    } else {
      print('❌ Failed to fetch conversations: ${response.body}');
      throw Exception('Failed to load conversations');
    }
  }

  static Future<bool> updateConversationTitle(String conversationId, String newTitle) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("User ID is NULL!");

    final uri = Uri.parse("$_baseUrl/chat/$userId/conversations/$conversationId/title");

    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'newTitle': newTitle
        }),
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
      throw Exception('Failed to update conversation title!');
    }
  }

  static Future<bool> deleteConversation(String conversationId) async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception("User is not logged in");

    final userId = await AuthService.getUserIdFromToken(token);
    if (userId == null) throw Exception("User ID is NULL!");

    final uri = Uri.parse("$_baseUrl/chat/$userId/conversations/$conversationId/delete");

    try {
      final response = await http.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
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
      throw Exception('Failed to delete converation!');
    }
  }
}