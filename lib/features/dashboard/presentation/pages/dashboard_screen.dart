import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:studysquare/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/presentation/pages/program_detail_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? dashboardData;
  Map<String, dynamic> _stats = {};
  List<Program> allPrograms = [];
  List<Program> enrolledPrograms = [];
  List<Program> recommendedPrograms = [];
  bool isLoading = true;
  int readCount = 0;

  @override
  void initState() {
    super.initState();
    loadDashboardData();

    _loadStats(); // Add this line

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        readCount = 3;
      });
    });
  }

  // Add this method
  Future<void> _loadStats() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final stats = await profileProvider.getOverallStats();
    if (mounted) {
      setState(() {
        _stats = stats;
      });
    }
  }

  Future<void> loadDashboardData() async {
    try {
      // Load dashboard + programs JSON in parallel
      final results = await Future.wait([
        rootBundle.loadString('assets/data/dashboard.json'),
        rootBundle.loadString('assets/data/programs.json'),
      ]);

      final dashboardJson = json.decode(results[0]);
      final programsJson = json.decode(results[1]);

      debugPrint('Dashboard JSON loaded: $dashboardJson');
      debugPrint('Programs JSON structure: ${programsJson.runtimeType}');

      // Only try to access keys if it's a Map
      if (programsJson is Map) {
        debugPrint('Programs JSON keys: ${programsJson.keys}');
      } else {
        debugPrint('Programs JSON length: ${programsJson.length}');
      }

      // Handle different JSON structures
      List<dynamic> programsData;
      if (programsJson is List) {
        programsData = programsJson;
      } else if (programsJson is Map && programsJson.containsKey('programs')) {
        programsData = programsJson['programs'];
      } else if (programsJson is Map && programsJson.containsKey('data')) {
        programsData = programsJson['data'];
      } else {
        throw Exception(
          'Unknown programs JSON structure: ${programsJson.runtimeType}',
        );
      }

      debugPrint('Programs data length: ${programsData.length}');
      if (programsData.isNotEmpty) {
        debugPrint('First program sample: ${programsData[0]}');
      }

      // Parse programs with error handling
      final List<Program> programsList = [];
      for (int i = 0; i < programsData.length; i++) {
        try {
          final programData = programsData[i];
          if (programData is Map<String, dynamic>) {
            final program = Program.fromJson(programData);
            programsList.add(program);
          } else {
            debugPrint(
              'Converting program at index $i: ${programData.runtimeType}',
            );
            final program = Program.fromJson(
              Map<String, dynamic>.from(programData),
            );
            programsList.add(program);
          }
        } catch (e, stackTrace) {
          debugPrint('Error parsing program at index $i: $e');
          debugPrint('Program data: ${programsData[i]}');
          debugPrint('Stack trace: $stackTrace');
          // Continue with other programs instead of failing completely
        }
      }

      debugPrint('Successfully parsed ${programsList.length} programs');

      setState(() {
        dashboardData = dashboardJson;
        allPrograms = programsList;
        isLoading = false;
      });

      // Load enrolled courses from profile
      _loadEnrolledCourses();
    } catch (e, stackTrace) {
      debugPrint('Error loading dashboard data: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() => isLoading = false);
    }
  }

  void _loadEnrolledCourses() {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final profile = profileProvider.profile;

    if (profile?.enrolledCourses != null) {
      final enrolledCourseIds = profile!.enrolledCourses!;

      setState(() {
        // Filter enrolled programs based on profile enrolled courses
        enrolledPrograms = allPrograms
            .where((program) => enrolledCourseIds.contains(program.id))
            .toList();

        // Get recommended programs (exclude enrolled ones)
        recommendedPrograms = allPrograms
            .where((program) => !enrolledCourseIds.contains(program.id))
            .take(3)
            .toList();
      });
    } else {
      setState(() {
        enrolledPrograms = [];
        recommendedPrograms = allPrograms.take(3).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        // Reload enrolled courses when profile changes
        if (!isLoading && profileProvider.profile != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadEnrolledCourses();
          });
        }

        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (dashboardData == null && allPrograms.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("Error loading dashboard data"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => isLoading = true);
                      loadDashboardData();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final profile = profileProvider.profile;
        final userName = profile?.name ?? 'User';
        final userRole = dashboardData?['role'] ?? 'learner';

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 0,
            title: Text(
              userRole == 'admin' ? 'Admin Dashboard' : 'Dashboard',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            actions: [
              // 🔔 Interactive Notification Badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () async {
                      setState(() => readCount = 0);
                      // Handle notification navigation safely
                      try {
                        await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotificationsScreen(userId: ''),
                          ),
                          (route) => route.isFirst,
                        );
                      } catch (e) {
                        debugPrint('Navigation error: $e');
                      }
                    },
                  ),
                  if (readCount > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$readCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👋 Welcome Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Welcome back, $userName 👋",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📊 Quick Stats Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard(
                      "Active Courses",
                      "${enrolledPrograms.length}",
                      Icons.book,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      "Total XP",
                      "${_stats['total_xp'] ?? 0}",
                      Icons.trending_up,
                      Colors.green,
                    ),
                    _buildStatCard(
                      "Streak",
                      "${profile?.streak ?? 0} days",
                      Icons.local_fire_department,
                      Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // 📘 Continue Learning Section
                const Text(
                  "Continue Learning",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                enrolledPrograms.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No active courses yet",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Enroll in a program below to start learning!",
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: enrolledPrograms.map((program) {
                          return _buildEnrolledCourseCard(program);
                        }).toList(),
                      ),

                const SizedBox(height: 25),

                // 💡 Recommended Programs Section
                const Text(
                  "Recommended Programs",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                if (recommendedPrograms.isNotEmpty)
                  Column(
                    children: recommendedPrograms
                        .map((program) => _buildProgramCard(program))
                        .toList(),
                  )
                else
                  const Text(
                    "All available programs have been enrolled!",
                    style: TextStyle(color: Colors.grey),
                  ),

                // Show total programs loaded for debugging
                if (allPrograms.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Loaded ${allPrograms.length} programs total",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 📦 Helper Widgets remain the same ---

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnrolledCourseCard(Program program) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return FutureBuilder<double>(
          future: provider.getCourseProgress(program.id),
          builder: (context, snapshot) {
            final progress = snapshot.data ?? 0.0;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgramDetailPage(program: program),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                program.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${program.duration} • ${program.level}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Enrolled",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      color: Colors.blueAccent,
                      backgroundColor: Colors.grey[200],
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}% complete",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProgramCard(Program program) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: Colors.blueAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "${program.duration} • ${program.level}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProgramDetailPage(program: program),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("View"),
          ),
        ],
      ),
    );
  }
}
