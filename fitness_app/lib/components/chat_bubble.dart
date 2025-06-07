import 'package:fitness_app/components/typing_text.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  final bool useTypingEffect;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isUser,
    this.useTypingEffect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(12),
      width: 500,
      decoration: BoxDecoration(
        color: isUser ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: useTypingEffect
          ? TypingText(
              text: content,
              isUser: isUser,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            )
          : Text(
              content,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
    );
  }
}