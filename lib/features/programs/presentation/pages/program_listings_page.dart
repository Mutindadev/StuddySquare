import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/data/services/program_service.dart';
import 'package:studysquare/features/programs/presentation/provider/enrollment_provider.dart';

import 'program_detail_page.dart';

class ProgramListingsPage extends StatelessWidget {
  const ProgramListingsPage({super.key});

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Palette.success;
      case 'intermediate':
        return Palette.warning;
      case 'advanced':
        return Palette.error;
      default:
        return Palette.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
        backgroundColor: Palette.primary,
        foregroundColor: Palette.textOnPrimary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Palette.background, Palette.surface],
          ),
        ),
        child: FutureBuilder<List<Program>>(
          future: ProgramService.loadPrograms(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Palette.primary),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No programs available',
                  style: TextStyle(color: Palette.textSecondary, fontSize: 16),
                ),
              );
            }

            final programs = snapshot.data!;

            return Consumer<EnrollmentProvider>(
              builder: (context, enrollmentProvider, _) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: programs.length,
                  itemBuilder: (context, index) {
                    final program = programs[index];
                    final programId = program.id;
                    final isEnrolled = enrollmentProvider.isEnrolled(programId);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      color: Palette.cardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProgramDetailPage(program: program),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          program.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Palette.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _getLevelColor(
                                                  program.level,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                program.level,
                                                style: const TextStyle(
                                                  color: Palette.textOnPrimary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            if (isEnrolled) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Palette.success,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  'Enrolled',
                                                  style: TextStyle(
                                                    color:
                                                        Palette.textOnPrimary,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                program.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Palette.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Palette.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    program.duration,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Palette.textSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    isEnrolled ? 'Continue' : 'View Details',
                                    style: const TextStyle(
                                      color: Palette.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Palette.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
