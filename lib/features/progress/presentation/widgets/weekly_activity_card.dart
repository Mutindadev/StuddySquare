import 'package:flutter/material.dart';
import '../utils/progress_colors.dart';
import '../../data/repositories/weekly_activity_repository.dart';

class WeeklyActivityCard extends StatefulWidget {
  const WeeklyActivityCard({super.key});

  @override
  State<WeeklyActivityCard> createState() => _WeeklyActivityCardState();
}

class _WeeklyActivityCardState extends State<WeeklyActivityCard> {
  late Future<Map<String, dynamic>> _weeklyActivityFuture;
  final WeeklyActivityRepository _repository = WeeklyActivityRepository();

  @override
  void initState() {
    super.initState();
    _weeklyActivityFuture = _repository.fetchWeeklyActivity();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _weeklyActivityFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No weekly activity data available.'));
        }

        final weeklyActivity = snapshot.data!;
        final totalMinutes = weeklyActivity['total_minutes'] ?? 0;
        final days =
            List<Map<String, dynamic>>.from(weeklyActivity['days'] ?? []);

        final maxMinutes = days.fold<int>(
          0,
          (max, day) => day['minutes'] > max ? day['minutes'] : max,
        );

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
                'Weekly Activity',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),

              // Bar Graph Section
              SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: days.map((day) {
                    final barHeight = maxMinutes > 0
                        ? (day['minutes'] / maxMinutes) * 100
                        : 0;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: barHeight,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day['day'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 12),
              Text(
                '$totalMinutes minutes this week',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }
}
