import 'package:flutter/material.dart';

class BadgesTab extends StatelessWidget {
  const BadgesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = [
      {'name': 'Beginner', 'emoji': '🥉'},
      {'name': 'Intermediate', 'emoji': '🥈'},
      {'name': 'Expert', 'emoji': '🥇'},
      {'name': 'Consistency', 'emoji': '🔥'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Earned Badges',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: badges.map((badge) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      badge['emoji']!,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamilyFallback: [
                          'Noto Color Emoji',
                          'Apple Color Emoji',
                          'Segoe UI Emoji'
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      badge['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

