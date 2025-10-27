import 'package:flutter/material.dart';
import '../utils/progress_colors.dart';
import 'goal_row.dart';
import '../../data/repositories/current_goals_repository.dart';

class CurrentGoalsCard extends StatefulWidget {
  const CurrentGoalsCard({super.key});

  @override
  State<CurrentGoalsCard> createState() => _CurrentGoalsCardState();
}

class _CurrentGoalsCardState extends State<CurrentGoalsCard> {
  late Future<Map<String, dynamic>> _goalsFuture;
  final CurrentGoalsRepository _repository = CurrentGoalsRepository();

  @override
  void initState() {
    super.initState();
    _goalsFuture = _repository.fetchCurrentGoals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _goalsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No goals available.'));
        }

        final goals = snapshot.data!;

        return Container(
          decoration: BoxDecoration(
            color: ProgressColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ProgressColors.cardBorder),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Goals',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              // Loop through map entries instead of list
              ...goals.entries.map((entry) {
                final goal = entry.value;
                final title = goal['title'] ?? 'Untitled Goal';
                final current = goal['current'] ?? 0;
                final target = goal['target'] ?? 1;
                final fraction = target > 0 ? current / target : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GoalRow(
                    title: title,
                    subtitle: '$current / $target',
                    fraction: fraction,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
