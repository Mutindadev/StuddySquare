// Learning point with success checkmark
import 'package:flutter/material.dart';
import 'package:studysquare/core/theme/palette.dart';

class LearningPoint extends StatelessWidget {
  final String text;

  const LearningPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Palette.success, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Palette.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
