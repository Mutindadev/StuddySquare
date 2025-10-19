import 'package:flutter/material.dart';
import 'enrolled_course_page.dart';

// StudySquare official colors from Figma design
const Color primaryBlue = Color(0xFF2B7FFF); // #2B7FFF
const Color primaryPurple = Color(0xFF9810FA); // #9810FA
const Color backgroundLight = Color(0xFFF9FAFB);
const Color cardWhite = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF1A1A1A);
const Color textGray = Color(0xFF64748B);

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
        backgroundColor: primaryPurple, // Purple AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with blue-to-purple gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryBlue, // Blue #2B7FFF
                    primaryPurple, // Purple #9810FA
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
                  Text(
                    'What You\'ll Learn',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...learning
                      .map((item) => _LearningPoint(text: item))
                      .toList(),
                  const SizedBox(height: 24),
                  Text(
                    'Prerequisites',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'No prior experience required. Just bring your enthusiasm and commitment to learn!',
                      style: TextStyle(fontSize: 15, color: textGray),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Course Outline',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textDark,
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
                  // Enroll Now button with gradient
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryBlue, primaryPurple],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
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

// Info card widget (Duration, Level)
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
        color: Color(0xFFF3E5FD), // Light purple background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE1BEFA)), // Light purple border
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: primaryPurple), // Purple icon
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: textGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryPurple, // Purple text
            ),
          ),
        ],
      ),
    );
  }
}

// Learning point with green checkmark
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
            color: Colors.green, // Green checkmark (stays green)
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: textDark),
            ),
          ),
        ],
      ),
    );
  }
}

// Module item (Week badge + title)
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
              color: primaryPurple, // Purple week badge
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textDark,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: textGray),
        ],
      ),
    );
  }
}
