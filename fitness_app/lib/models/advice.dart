class Advice {
  final String id;
  final String title;
  final String message;
  final DateTime date;

  Advice({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });

  factory Advice.fromJson(Map<String, dynamic> json) {
    return Advice(
      id: json['id'],
      title: json['title'],
      message: json['advice'],
      date: DateTime.parse(json['createdAt']),
    );
  }
}