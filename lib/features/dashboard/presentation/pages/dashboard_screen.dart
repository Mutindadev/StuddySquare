import 'package:flutter/material.dart';
import 'package:studysquare/core/theme/palette.dart';
import '../../data/local_json_service.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final LocalJsonService _jsonService = LocalJsonService();
  Map<String, dynamic>? dashboardData;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final data = await _jsonService.loadDashboard();
    setState(() {
      dashboardData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dashboardData == null) {
      return const Scaffold(
        backgroundColor: Palette.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final progress = dashboardData!['progress'];
    final stats = dashboardData!['stats'] as List<dynamic>;
    final courses = dashboardData!['courses'] as List<dynamic>;
    final actions = dashboardData!['actions'] as List<dynamic>;

    return Scaffold(
      backgroundColor: Palette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Palette.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Continue your learning journey',
                        style: TextStyle(
                          fontSize: 16,
                          color: Palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Palette.containerLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Palette.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Progress Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: Palette.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.shadowMedium,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Palette.textOnPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      progress['message'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Palette.textOnPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: progress['percent'],
                      backgroundColor: Palette.textOnPrimary.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Palette.textOnPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      progress['text'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Palette.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Stats
              Row(
                children: stats
                    .map(
                      (stat) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildStatCard(
                            stat['label'],
                            stat['value'],
                            getIconFromString(stat['icon']),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Continue Learning Section
              const Text(
                'Continue Learning',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Palette.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              Column(
                children: courses
                    .map(
                      (course) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCourseCard(
                          course['title'],
                          course['subtitle'],
                          course['progress'],
                          getIconFromString(course['icon']),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Palette.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: actions
                    .map(
                      (action) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildActionButton(
                            action['label'],
                            getIconFromString(action['icon']),
                            action['color'] == 'primary'
                                ? Palette.primary
                                : Palette.secondary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(12),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Palette.containerLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Palette.primary, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Palette.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
      String title, String subtitle, double progress, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Palette.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Palette.containerLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Palette.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Palette.borderLight,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Palette.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toInt()}% Complete',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Palette.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Palette.textTertiary),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Helper to map string to IconData
IconData getIconFromString(String iconName) {
  switch (iconName) {
    case 'book_outlined':
      return Icons.book_outlined;
    case 'access_time':
      return Icons.access_time;
    case 'local_fire_department':
      return Icons.local_fire_department;
    case 'security':
      return Icons.security;
    case 'web':
      return Icons.web;
    case 'explore_outlined':
      return Icons.explore_outlined;
    case 'analytics_outlined':
      return Icons.analytics_outlined;
    default:
      return Icons.help_outline;
  }
}
