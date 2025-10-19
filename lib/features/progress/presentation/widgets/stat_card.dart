import 'package:flutter/material.dart';
import '../utils/progress_colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
  });

  Widget _smallIconCircle(IconData icon, Color bg, Color iconColor) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(child: Icon(icon, size: 18, color: iconColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProgressColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProgressColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: _smallIconCircle(icon, iconBg.withOpacity(0.18), iconBg),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
