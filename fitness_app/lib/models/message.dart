class Message {
  final String id;
  final String conversationId;
  final String sender;
  final String content;
  final DateTime createdAt;

  Message({required this.id, required this.conversationId, required this.sender, required this.content, required this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    conversationId: json['conversationId'],
    sender: json['sender'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "conversationId": conversationId,
      "sender": sender,
      "content": content,
      "createdAt": createdAt
    };
  }
}
