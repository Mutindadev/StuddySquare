import 'package:flutter/material.dart';
import '../utils/progress_colors.dart';

class GoalRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final double fraction;

  const GoalRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (fraction * 100).clamp(0.0, 100.0).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            minHeight: 10,
            backgroundColor: const Color(0xFFF1F5F9),
            value: fraction.clamp(0.0, 1.0),
            valueColor: const AlwaysStoppedAnimation(ProgressColors.progressFill),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
