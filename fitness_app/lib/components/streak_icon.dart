import 'package:flutter/material.dart';

Widget streakIcon(int streakCount, String type) {
  IconData icon = Icons.local_fire_department;
  Color flameColor = Colors.deepOrange;

  return Row(
    children: [
      Icon(icon, color: flameColor, size: 28),
      const SizedBox(width: 6),
      Text(
        '$streakCount day${streakCount == 1 ? '' : 's'} streak!',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
          fontSize: 16,
        ),
      ),
      const SizedBox(width: 4),
      Text(
        type == 'intake' ? '🔥 Intake' : '💪 Burn',
        style: TextStyle(color: Colors.grey[700]),
      )
    ],
  );
}
