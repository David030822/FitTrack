import 'message.dart';

class Conversation {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final List<Message>? messages;

  Conversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.lastUpdated,
    this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((m) => Message.fromJson(m))
              .toList()
          : null, // ✅ Safe fallback
    );
  }
}