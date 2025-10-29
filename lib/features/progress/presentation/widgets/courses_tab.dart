import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/data/services/program_service.dart';

import '../../data/repositories/courses_repository.dart';

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  late Future<List<dynamic>> _coursesFuture;
  final CoursesRepository _repository = CoursesRepository();

  @override
  void initState() {
    super.initState();
    _coursesFuture = _repository.fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No courses available.'));
        }

        // final courses = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ProfileProvider>(
              builder: (context, provider, _) {
                if (provider.profile == null ||
                    provider.profile!.enrolledCourses == null) {
                  return const Center(child: Text('No enrolled courses'));
                }

                return FutureBuilder<Map<String, double>>(
                  future: provider.getAllCoursesProgress(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final progress = snapshot.data!;
                    final courses = provider.profile!.enrolledCourses!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enrolled Courses',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...courses.map((programId) {
                          return FutureBuilder<Program?>(
                            future: ProgramService.getProgramById(programId),
                            builder: (context, programSnapshot) {
                              if (!programSnapshot.hasData) {
                                return const SizedBox();
                              }

                              final program = programSnapshot.data!;
                              final courseProgress = progress[programId] ?? 0.0;

                              return Container(
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
                                      program.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: courseProgress,
                                      backgroundColor: const Color(0xFFF3F4F6),
                                      color: Colors.green,
                                      minHeight: 8,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
