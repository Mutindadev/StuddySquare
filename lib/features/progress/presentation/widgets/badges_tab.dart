import 'package:flutter/material.dart';
import '../../data/repositories/badges_repository.dart';

class BadgesTab extends StatefulWidget {
  const BadgesTab({super.key});

  @override
  State<BadgesTab> createState() => _BadgesTabState();
}

class _BadgesTabState extends State<BadgesTab> {
  final BadgesRepository _repository = BadgesRepository();
  late Future<List<dynamic>> _badgesFuture;

  @override
  void initState() {
    super.initState();
    _badgesFuture = _repository.fetchBadges();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _badgesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No badges available.'));
        }

        final badges = snapshot.data!;

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
                          badge['emoji'] ?? '🏅',
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
                          badge['name'] ?? 'Unknown',
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
      },
    );
  }
}
