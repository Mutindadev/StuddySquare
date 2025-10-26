import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? dashboardData;
  List<dynamic>? programs;
  bool isLoading = true;
  int readCount = 0; // 🔔 Notification badge count

  @override
  void initState() {
    super.initState();
    loadDashboardData();

    // Simulate new notifications (can be replaced with real JSON logic later)
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        readCount = 3;
      });
    });
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

      setState(() {
        dashboardData = dashboardJson;
        programs = programsJson['programs'];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (dashboardData == null) {
      return const Scaffold(
        body: Center(child: Text("Error loading dashboard data")),
      );
    }

    final userName = dashboardData!['userName'] ?? 'User';
    final userRole = dashboardData!['role'] ?? 'learner';
    final courses = dashboardData!['courses'] ?? [];

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
                icon: const Icon(Icons.notifications_outlined, color: Colors.blueAccent),
                onPressed: () async {
                  setState(() => readCount = 0); // reset when opened
                  await Navigator.pushNamed(context, '/notifications');
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
                _buildStatCard("Active Courses", "${courses.length}", Icons.book, Colors.orange),
                _buildStatCard("Progress", "75%", Icons.trending_up, Colors.green),
                _buildStatCard("Achievements", "5", Icons.star, Colors.purple),
              ],
            ),

            const SizedBox(height: 25),

            // 📘 Continue Learning Section
            const Text(
              "Continue Learning",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            courses.isEmpty
                ? const Text(
                    "No active courses yet. Enroll in a program to start learning!",
                    style: TextStyle(color: Colors.grey),
                  )
                : Column(
                    children: courses.map((course) {
                      final title = course['title'] ?? 'Untitled';
                      final progress = (course['progress'] ?? 0.0) * 100;
                      return _buildCourseCard(title, progress);
                    }).toList(),
                  ),

            const SizedBox(height: 25),

            // 💡 Recommended Programs Section
            const Text(
              "Recommended Programs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (programs != null)
              Column(
                children: programs!
                    .take(3)
                    .map((program) => _buildProgramCard(program))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  // --- 📦 Helper Widgets ---

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, spreadRadius: 3),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(String title, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, spreadRadius: 3),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress / 100,
            color: Colors.blueAccent,
            backgroundColor: Colors.grey[200],
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 6),
          Text("${progress.toStringAsFixed(0)}% complete",
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program) {
    final name = program['name'] ?? 'Program';
    final duration = program['duration'] ?? 'N/A';
    final level = program['level'] ?? 'Beginner';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, spreadRadius: 3),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("$duration • $level",
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("View"),
          ),
        ],
      ),
    );
  }
}
