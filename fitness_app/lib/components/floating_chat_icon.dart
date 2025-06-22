import 'package:fitness_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class FloatingChatIcon extends StatelessWidget {
  const FloatingChatIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage())),
        child: const Icon(Icons.chat),
      ),
    );
  }
}