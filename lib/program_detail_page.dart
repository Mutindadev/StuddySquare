import 'package:flutter/material.dart';
import 'enrolled_course_page.dart';

class ProgramDetailPage extends StatelessWidget {
  final Map<String, dynamic> program;

  const ProgramDetailPage({Key? key, required this.program}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = program['title']?.toString() ?? 'Program';
    final description = program['description']?.toString() ?? '';
    final duration = program['duration']?.toString() ?? '';
    final level = program['level']?.toString() ?? '';

    List<String> learning = [];
    if (program['learning'] is List) {
      learning =
          (program['learning'] as List).map((e) => e.toString()).toList();
    } else {
      learning = [
        'Master key concepts and skills',
        'Work on real-world projects',
        'Get certified upon completion',
        'Access to exclusive resources',
        'Career support and mentorship',
      ];
    }

    List<Map<String, dynamic>> modules = [];
    if (program['modules'] is List) {
      modules = (program['modules'] as List).map((e) {
        if (e is Map) {
          return Map<String, dynamic>.from(e);
        }
        return <String, dynamic>{};
      }).toList();
    } else {
      modules = [
        {'week': 'Week 1-2', 'title': 'Introduction & Fundamentals'},
        {'week': 'Week 3-4', 'title': 'Core Concepts'},
        {'week': 'Week 5-6', 'title': 'Advanced Topics'},
        {'week': 'Week 7-8', 'title': 'Final Project'},
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Details'),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red,
                    Colors.red.shade700,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.access_time,
                          title: 'Duration',
                          value: duration,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.bar_chart,
                          title: 'Level',
                          value: level,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'What You\'ll Learn',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...learning
                      .map((item) => _LearningPoint(text: item))
                      .toList(),
                  const SizedBox(height: 24),
                  const Text(
                    'Prerequisites',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'No prior experience required. Just bring your enthusiasm and commitment to learn!',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Course Outline',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...modules
                      .map((mod) => _ModuleItem(
                            week: mod['week']?.toString() ?? '',
                            title: mod['title']?.toString() ?? '',
                          ))
                      .toList(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EnrolledCoursePage(program: program),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Enroll Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningPoint extends StatelessWidget {
  final String text;

  const _LearningPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleItem extends StatelessWidget {
  final String week;
  final String title;

  const _ModuleItem({required this.week, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              week,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
