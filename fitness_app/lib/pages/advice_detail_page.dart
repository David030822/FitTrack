import 'package:flutter/material.dart';
import '../models/advice.dart';

class AdviceDetailPage extends StatelessWidget {
  final Advice advice;

  const AdviceDetailPage({required this.advice, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(advice.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              advice.message,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}