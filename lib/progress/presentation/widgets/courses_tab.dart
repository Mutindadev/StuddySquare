import 'package:flutter/material.dart';

class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {'title': 'Flutter Development', 'progress': 0.6},
      {'title': 'UI/UX Design', 'progress': 0.3},
      {'title': 'Data Structures', 'progress': 0.8},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Courses',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...courses.map((course) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: course['progress'] as double,
                    backgroundColor: const Color(0xFFF3F4F6),
                    color: Colors.green,
                    minHeight: 8,
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

