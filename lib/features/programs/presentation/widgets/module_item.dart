// Enhanced Module item using Module model
import 'package:flutter/material.dart';
import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/programs/data/models/program.dart';

class ModuleItem extends StatelessWidget {
  final Module module;

  const ModuleItem({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.surface,
        border: Border.all(color: Palette.borderLight),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Palette.shadowLight,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Palette.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  module.week,
                  style: const TextStyle(
                    color: Palette.textOnPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  module.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Palette.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Palette.textTertiary,
              ),
            ],
          ),

          // Show task count if available
          if (module.tasks.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.assignment_outlined,
                  size: 16,
                  color: Palette.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${module.tasks.length} tasks',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Palette.textTertiary,
                  ),
                ),
                const SizedBox(width: 16),
                // Show task types
                ...module.tasks
                    .take(3)
                    .map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          _getTaskIcon(task.type),
                          size: 14,
                          color: _getTaskColor(task.type),
                        ),
                      ),
                    )
                    .toList(),
                if (module.tasks.length > 3)
                  Text(
                    '+${module.tasks.length - 3}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Palette.textTertiary,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTaskIcon(TaskType type) {
    switch (type) {
      case TaskType.reading:
        return Icons.menu_book;
      case TaskType.quiz:
        return Icons.quiz;
      case TaskType.project:
        return Icons.code;
    }
  }

  Color _getTaskColor(TaskType type) {
    switch (type) {
      case TaskType.reading:
        return Palette.primary;
      case TaskType.quiz:
        return Palette.warning;
      case TaskType.project:
        return Palette.secondary;
    }
  }
}
