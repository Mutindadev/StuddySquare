import 'package:flutter/material.dart';
import 'package:studysquare/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:studysquare/features/profile/presentation/pages/profilepage.dart';
import 'package:studysquare/features/programs/presentation/pages/program_listings_page.dart';
import 'package:studysquare/features/progress/presentation/pages/progress_page.dart';
// ...existing imports...

class HomePage extends StatefulWidget {
  final int? initialPage;
  const HomePage({super.key, this.initialPage});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialPage ?? 0);
    selectedIndex = widget.initialPage ?? 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        key: const Key('homePageView'),
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const DashboardScreen(),
          ProgramListingsPage(),
          const ProgressPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        key: const Key('homePageNavigationBar'),
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
            _controller.jumpToPage(index);
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book_rounded),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_stats_outlined),
            selectedIcon: Icon(Icons.query_stats_rounded),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
