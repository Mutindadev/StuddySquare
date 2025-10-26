import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/presentation/provider/enrollment_provider.dart';

import 'enrolled_course_page.dart';

class ProgramDetailPage extends StatelessWidget {
  final Program program;

  const ProgramDetailPage({Key? key, required this.program}) : super(key: key);

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
                        child: _InfoCard(
                          icon: Icons.access_time,
                          title: 'Duration',
                          value: program.duration,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
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
                        child: _InfoCard(
                          icon: Icons.assignment,
                          title: 'Tasks',
                          value: '${program.totalTasks}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
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
                    const _LearningPoint(text: 'Master key concepts and skills')
                  else
                    ...program.learning
                        .map((item) => _LearningPoint(text: item))
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
                        .map((module) => _ModuleItem(module: module))
                        .toList(),

                  const SizedBox(height: 32),

                  // Enroll Now / Continue button with gradient
                  Consumer<EnrollmentProvider>(
                    builder: (context, enrollmentProvider, _) {
                      final isEnrolled = enrollmentProvider.isEnrolled(
                        program.id,
                      );

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
                                await enrollmentProvider.enroll(program.id);

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

// Enhanced Info card widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? levelColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.containerLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (levelColor ?? Palette.primary).withOpacity(0.3),
        ),
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
          Icon(icon, size: 32, color: levelColor ?? Palette.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Palette.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: levelColor ?? Palette.primary,
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

// Enhanced Module item using Module model
class _ModuleItem extends StatelessWidget {
  final Module module;

  const _ModuleItem({required this.module});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Palette.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  module.week,
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
                  module.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

          // Show task count if available
          if (module.tasks.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.assignment_outlined,
                  size: 16,
                  color: Palette.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${module.tasks.length} tasks',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Palette.textTertiary,
                  ),
                ),
                const SizedBox(width: 16),
                // Show task types
                ...module.tasks
                    .take(3)
                    .map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          _getTaskIcon(task.type),
                          size: 14,
                          color: _getTaskColor(task.type),
                        ),
                      ),
                    )
                    .toList(),
                if (module.tasks.length > 3)
                  Text(
                    '+${module.tasks.length - 3}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Palette.textTertiary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTaskIcon(TaskType type) {
    switch (type) {
      case TaskType.reading:
        return Icons.menu_book;
      case TaskType.quiz:
        return Icons.quiz;
      case TaskType.project:
        return Icons.code;
    }
  }

  Color _getTaskColor(TaskType type) {
    switch (type) {
      case TaskType.reading:
        return Palette.primary;
      case TaskType.quiz:
        return Palette.warning;
      case TaskType.project:
        return Palette.secondary;
    }
  }
}
