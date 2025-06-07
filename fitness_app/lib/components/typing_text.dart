import 'dart:async';
import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final String text;
  final Duration speed;
  final TextStyle? style;
  final bool isUser;

  const TypingText({
    super.key,
    required this.text,
    this.speed = const Duration(milliseconds: 20),
    this.style,
    this.isUser = false,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> with SingleTickerProviderStateMixin {
  String _displayed = "";
  Timer? _timer;
  int _index = 0;

  late AnimationController _blinkController;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _startTyping();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 1, end: 0).animate(_blinkController);
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_index >= widget.text.length) {
        timer.cancel();
        _blinkController.stop();
      } else {
        setState(() {
          _displayed += widget.text[_index];
          _index++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: widget.style,
        children: [
          TextSpan(text: _displayed),
          if (_index < widget.text.length)
            WidgetSpan(
              child: FadeTransition(
                opacity: _opacity,
                child: const Text('|', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}