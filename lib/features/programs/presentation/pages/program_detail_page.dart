import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/palette.dart';

import '../providers/enrollment_provider.dart';
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
    final programId = program['id']?.toString() ?? '';

    List<String> learning = [];
    if (program['learning'] is List) {
      learning = (program['learning'] as List)
          .map((e) => e.toString())
          .toList();
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
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: const Text('Program Details'),
        backgroundColor: Palette.primary,
        foregroundColor: Palette.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with primary gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: Palette.primaryGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Palette.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Palette.textOnPrimary.withOpacity(0.9),
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
                      color: Palette.textPrimary,
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
                      color: Palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Palette.containerLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Palette.primary.withOpacity(0.2),
                      ),
                    ),
                    child: const Text(
                      'No prior experience required. Just bring your enthusiasm and commitment to learn!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Palette.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Course Outline',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...modules
                      .map(
                        (mod) => _ModuleItem(
                          week: mod['week']?.toString() ?? '',
                          title: mod['title']?.toString() ?? '',
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 32),
                  // Enroll Now / Continue button with gradient
                  Consumer<EnrollmentProvider>(
                    builder: (context, enrollmentProvider, _) {
                      final isEnrolled = enrollmentProvider.isEnrolled(programId);
                      
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: Palette.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Palette.shadowMedium,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isEnrolled) {
                                // Navigate to enrolled course page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EnrolledCoursePage(program: program),
                                  ),
                                );
                              } else {
                                // Enroll the user
                                await enrollmentProvider.enroll(programId);
                                
                                // Navigate to enrolled course page
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EnrolledCoursePage(program: program),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isEnrolled ? 'Continue' : 'Enroll Now',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Palette.textOnPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
        color: Palette.containerLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Palette.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Palette.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Palette.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Palette.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// Learning point with success checkmark
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
        color: Palette.surface,
        border: Border.all(color: Palette.borderLight),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Palette.shadowLight,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Palette.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              week,
              style: const TextStyle(
                color: Palette.textOnPrimary,
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
                color: Palette.textPrimary,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Palette.textTertiary,
          ),
        ],
      ),
    );
  }
}
