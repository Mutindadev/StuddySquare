import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final profile = profileProvider.profile;
        final enrolledCourses = profile?.enrolledCourses ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Activity Section
            const Text(
              'Weekly Activity',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildWeekDays(),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<List<double>>(
                    future: profileProvider.getWeeklyActivity(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final activityData = snapshot.data ?? List.filled(7, 0.0);
                      return SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: activityData
                              .map((value) => _buildActivityBar(value))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Current Goals Section
            const Text(
              'Current Goals',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.wait(
                  enrolledCourses.map((courseId) async {
                    final progress = await profileProvider.getCourseProgress(
                      courseId,
                    );
                    return {'title': courseId, 'progress': progress};
                  }).toList(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final goals = snapshot.data ?? [];
                  return Column(
                    children: goals.map((goal) {
                      return Column(
                        children: [
                          _goalItem(
                            goal['title'] as String,
                            (goal['progress'] as double),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildWeekDays() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days
        .map(
          (day) => Text(
            day,
            style: TextStyle(
              color: _isCurrentDay(day) ? Colors.green : Colors.grey,
              fontWeight: _isCurrentDay(day)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        )
        .toList();
  }

  bool _isCurrentDay(String day) {
    final now = DateTime.now();
    final weekDay = now.weekday;
    final days = {
      'Mon': 1,
      'Tue': 2,
      'Wed': 3,
      'Thu': 4,
      'Fri': 5,
      'Sat': 6,
      'Sun': 7,
    };
    return days[day] == weekDay;
  }

  Widget _buildActivityBar(double value) {
    return Container(
      width: 30,
      height: value * 100,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
    );
  }

  Widget _goalItem(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF3F4F6),
            color: Colors.green[700],
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
