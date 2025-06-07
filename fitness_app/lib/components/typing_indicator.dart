import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotOneAnim, _dotTwoAnim, _dotThreeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();

    _dotOneAnim = Tween<double>(begin: 0.0, end: 8.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
    ));

    _dotTwoAnim = Tween<double>(begin: 0.0, end: 8.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.6, curve: Curves.easeInOut),
    ));

    _dotThreeAnim = Tween<double>(begin: 0.0, end: 8.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Container(
          width: 8,
          height: 8 + animation.value,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(_dotOneAnim),
        _buildDot(_dotTwoAnim),
        _buildDot(_dotThreeAnim),
      ],
    );
  }
}
