import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';

// Import your repository
import '../../data/repositories/progress_repository.dart';
import '../utils/progress_colors.dart';
import '../widgets/badges_tab.dart';
import '../widgets/courses_tab.dart';
import '../widgets/current_goals_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/tab_section.dart';
import '../widgets/weekly_activity_card.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate initial load time (useful when using a local API)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  Future<void> _onTabSelected(int index) async {
    if (_selectedTab == index) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay (mimicking local API fetch)
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _selectedTab = index;
        _isLoading = false;
      });
    }
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeeklyActivityCard(),
            SizedBox(height: 14),
            CurrentGoalsCard(),
            SizedBox(height: 20),
          ],
        );
      case 1:
        return const CoursesTab();
      case 2:
        return const BadgesTab();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    const sidePadding = 16.0;

    return Scaffold(
      backgroundColor: ProgressColors.pageBg,
      body: Stack(
        children: [
          // MAIN CONTENT
          AnimatedOpacity(
            opacity: _isLoading ? 0.3 : 1.0,
            duration: const Duration(milliseconds: 400),
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: sidePadding,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _StatsGrid(),
                    const SizedBox(height: 16),
                    TabSection(
                      selectedIndex: _selectedTab,
                      onTabSelected: _onTabSelected,
                    ),
                    const SizedBox(height: 12),
                    _buildTabContent(),
                  ],
                ),
              ),
            ),
          ),

          // LOADER OVERLAY
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatefulWidget {
  const _StatsGrid();

  @override
  State<_StatsGrid> createState() => _StatsGridState();
}

class _StatsGridState extends State<_StatsGrid> {
  late Future<Map<String, dynamic>> _statsFuture;
  final ProgressRepository _repository = ProgressRepository();

  @override
  void initState() {
    super.initState();
    _statsFuture = _repository.getStatsData();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    _statsFuture = profileProvider.getOverallStats();
  }

  // Refresh stats when tab is selected
  void refreshStats() {
    setState(() {
      _loadStats();
    });
  }

  IconData _getIconForKey(String key) {
    switch (key) {
      case 'total_xp':
        return Icons.emoji_events;
      case 'day_streak':
        return Icons.local_fire_department;
      case 'lessons_done':
        return Icons.menu_book;
      case 'hours_learned':
        return Icons.show_chart;
      default:
        return Icons.help_outline;
    }
  }

  String _getLabelForKey(String key) {
    switch (key) {
      case 'total_xp':
        return 'Total XP';
      case 'day_streak':
        return 'Day Streak';
      case 'lessons_done':
        return 'Lessons Done';
      case 'hours_learned':
        return 'Hours Learned';
      default:
        return key;
    }
  }

  Color _getColorForKey(String key) {
    switch (key) {
      case 'total_xp':
        return Colors.green;
      case 'day_streak':
        return Colors.orange;
      case 'lessons_done':
        return Colors.blue;
      case 'hours_learned':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No stats available.'));
        }

        final stats = snapshot.data!;
        final entries = stats.entries.toList();

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final key = entry.key;
            final value = entry.value.toString();

            return StatCard(
              label: _getLabelForKey(key),
              value: value,
              icon: _getIconForKey(key),
              iconBg: _getColorForKey(key),
            );
          },
        );
      },
    );
  }
}
