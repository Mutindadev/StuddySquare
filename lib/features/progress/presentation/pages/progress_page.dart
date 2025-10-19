import 'package:flutter/material.dart';
import '../utils/progress_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/tab_section.dart';
import '../widgets/weekly_activity_card.dart';
import '../widgets/current_goals_card.dart';
import '../widgets/courses_tab.dart';
import '../widgets/badges_tab.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _selectedTab = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const sidePadding = 16.0;

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

    return Scaffold(
      backgroundColor: ProgressColors.pageBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: sidePadding, vertical: 16),
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
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      children: const [
        StatCard(
          label: 'Total XP',
          value: '0',
          icon: Icons.emoji_events,
          iconBg: Color(0xFFF59E0B),
        ),
        StatCard(
          label: 'Day Streak',
          value: '0',
          icon: Icons.local_fire_department,
          iconBg: Color(0xFFFB923C),
        ),
        StatCard(
          label: 'Lessons Done',
          value: '0',
          icon: Icons.menu_book,
          iconBg: Color(0xFF60A5FA),
        ),
        StatCard(
          label: 'Hours Learned',
          value: '0.0',
          icon: Icons.show_chart,
          iconBg: Color(0xFF86EFAC),
        ),
      ],
    );
  }
}
