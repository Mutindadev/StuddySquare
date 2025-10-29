// Enhanced Info card widget
import 'package:flutter/material.dart';
import 'package:studysquare/core/theme/palette.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? levelColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.containerLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (levelColor ?? Palette.primary).withOpacity(0.3),
        ),
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
          Icon(icon, size: 32, color: levelColor ?? Palette.primary),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Palette.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: levelColor ?? Palette.primary,
            ),
          ),
        ],
      ),
    );
  }
}
