import 'package:flutter/material.dart';
import '../utils/progress_colors.dart';
import 'goal_row.dart';

class CurrentGoalsCard extends StatelessWidget {
  const CurrentGoalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProgressColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProgressColors.cardBorder),
      ),
      padding: const EdgeInsets.all(14),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Goals',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          GoalRow(title: 'Weekly Goal', subtitle: '285 / 300 min', fraction: 285 / 300),
          GoalRow(title: 'Monthly XP Goal', subtitle: '1,420 / 2,000', fraction: 1420 / 2000),
        ],
      ),
    );
  }
}
