import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/presentation/provider/enrollment_provider.dart';
import 'package:studysquare/features/programs/presentation/widgets/info_data.dart';
import 'package:studysquare/features/programs/presentation/widgets/learning_point.dart';
import 'package:studysquare/features/programs/presentation/widgets/module_item.dart';

import 'enrolled_course_page.dart';

class ProgramDetailPage extends StatelessWidget {
  final Program program;

  const ProgramDetailPage({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
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
                    program.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Palette.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    program.description,
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
                  // Program info cards
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          icon: Icons.access_time,
                          title: 'Duration',
                          value: program.duration,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          icon: Icons.bar_chart,
                          title: 'Level',
                          value: program.level,
                          levelColor: _getLevelColor(program.levelEnum),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Additional info cards
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          icon: Icons.assignment,
                          title: 'Tasks',
                          value: '${program.totalTasks}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          icon: Icons.library_books,
                          title: 'Modules',
                          value: '${program.modules.length}',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // What you'll learn section
                  const Text(
                    'What You\'ll Learn',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (program.learning.isEmpty)
                    const LearningPoint(text: 'Master key concepts and skills')
                  else
                    ...program.learning
                        .map((item) => LearningPoint(text: item))
                        .toList(),

                  const SizedBox(height: 24),

                  // Prerequisites section
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
                    child: Text(
                      _getPrerequisiteText(program.levelEnum),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Palette.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Course outline section
                  const Text(
                    'Course Outline',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (program.modules.isEmpty)
                    const Text(
                      'Module information will be available soon.',
                      style: TextStyle(
                        color: Palette.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    ...program.modules
                        .map((module) => ModuleItem(module: module))
                        .toList(),

                  const SizedBox(height: 32),

                  // Enroll Now / Continue button with gradient
                  Consumer2<EnrollmentProvider, ProfileProvider>(
                    builder: (context, enrollmentProvider, profileProvider, _) {
                      final isEnrolled =
                          enrollmentProvider.isEnrolled(program.id) ||
                          profileProvider.isEnrolledInCourse(program.id);

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
                                try {
                                  // Enroll the user in enrollment system
                                  await enrollmentProvider.enroll(program.id);

                                  // Update profile with enrolled course
                                  await profileProvider.enrollInCourse(
                                    program.id,
                                  );

                                  // Show success message
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Successfully enrolled in ${program.title}',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    // Navigate to enrolled course page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EnrolledCoursePage(
                                          program: program,
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // Show error message
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to enroll: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isEnrolled ? Icons.play_arrow : Icons.school,
                                  color: Palette.textOnPrimary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isEnrolled
                                      ? 'Continue Learning'
                                      : 'Enroll Now',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Palette.textOnPrimary,
                                  ),
                                ),
                              ],
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

  Color _getLevelColor(ProgramLevel level) {
    switch (level) {
      case ProgramLevel.beginner:
        return Palette.success;
      case ProgramLevel.intermediate:
        return Palette.warning;
      case ProgramLevel.advanced:
        return Palette.error;
    }
  }

  String _getPrerequisiteText(ProgramLevel level) {
    switch (level) {
      case ProgramLevel.beginner:
        return 'No prior experience required! Perfect for those just starting their learning journey.';
      case ProgramLevel.intermediate:
        return 'Basic understanding of the topic recommended. Some prior experience will be helpful.';
      case ProgramLevel.advanced:
        return 'Strong foundation in the subject area required. This course builds on advanced concepts.';
    }
  }
}
