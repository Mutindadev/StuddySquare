import 'package:flutter/material.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weekly Activity Section
        const Text(
          'Weekly Activity',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Mon', style: TextStyle(color: Colors.grey)),
                  Text('Tue', style: TextStyle(color: Colors.grey)),
                  Text('Wed', style: TextStyle(color: Colors.grey)),
                  Text('Thu', style: TextStyle(color: Colors.grey)),
                  Text('Fri', style: TextStyle(color: Colors.grey)),
                  Text('Sat', style: TextStyle(color: Colors.grey)),
                  Text('Sun', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 100,
                color: const Color(0xFFF3F4F6),
                child: const Center(
                  child: Text(
                    '📈 Activity Graph Placeholder',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Current Goals Section
        const Text(
          'Current Goals',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _goalItem('Complete Flutter Basics', 0.7),
              const SizedBox(height: 12),
              _goalItem('Finish UI Design Module', 0.4),
            ],
          ),
        ),
      ],
    );
  }

  Widget _goalItem(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF3F4F6),
            color: Colors.green[700],
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
