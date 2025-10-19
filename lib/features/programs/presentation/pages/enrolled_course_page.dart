import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studysquare/core/theme/palette.dart';

import 'mini_project_page.dart';
import 'quiz_page.dart';

class EnrolledCoursePage extends StatefulWidget {
  final Map<String, dynamic> program;

  const EnrolledCoursePage({Key? key, required this.program}) : super(key: key);

  @override
  State<EnrolledCoursePage> createState() => _EnrolledCoursePageState();
}

class _EnrolledCoursePageState extends State<EnrolledCoursePage> {
  late final List<Map<String, dynamic>> modules;
  late final String programId;

  final Map<int, Set<String>> _completedTasks = {};
  final List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    programId = widget.program['id']?.toString() ?? 'unknown';

    final raw = widget.program['modules'];
    if (raw is List) {
      modules = raw.map((e) {
        if (e is Map) {
          return Map<String, dynamic>.from(e);
        }
        return <String, dynamic>{};
      }).toList();
    } else {
      modules = [
        {
          'week': 'Week 1-2',
          'title': 'Introduction',
          'tasks': [
            {'name': 'Reading', 'type': 'reading'},
            {'name': 'Quiz', 'type': 'quiz'},
            {'name': 'Mini Project', 'type': 'project'},
          ],
        },
      ];
    }

    for (int i = 0; i < modules.length; i++) {
      _completedTasks[i] = <String>{};
      _isExpanded.add(i == 0);
    }

    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'progress_$programId';
    final saved = prefs.getString(key);

    if (saved != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(saved);
        setState(() {
          data.forEach((moduleIndexStr, taskList) {
            final moduleIndex = int.parse(moduleIndexStr);
            if (taskList is List) {
              _completedTasks[moduleIndex] = Set<String>.from(taskList);
            }
          });
        });
      } catch (e) {
        debugPrint('Error loading progress: $e');
      }
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'progress_$programId';

    final Map<String, List<String>> data = {};
    _completedTasks.forEach((moduleIndex, taskSet) {
      data[moduleIndex.toString()] = taskSet.toList();
    });

    await prefs.setString(key, jsonEncode(data));
  }

  int get _totalTasks {
    int total = 0;
    for (var module in modules) {
      final tasks = module['tasks'];
      if (tasks is List) {
        total += tasks.length;
      }
    }
    return total;
  }

  int get _completedCount =>
      _completedTasks.values.fold(0, (s, set) => s + set.length);
  double get _progress =>
      _totalTasks == 0 ? 0.0 : (_completedCount / _totalTasks);

  bool _isModuleUnlocked(int index) {
    if (index == 0) return true;

    final prevModule = modules[index - 1];
    final prevTasks = prevModule['tasks'];
    final prevTaskCount = (prevTasks is List) ? prevTasks.length : 0;
    final prevCompleted = _completedTasks[index - 1]?.length ?? 0;

    return prevCompleted >= prevTaskCount;
  }

  void _toggleTask(int moduleIndex, String taskId, bool value) {
    setState(() {
      final set = _completedTasks[moduleIndex]!;
      if (value) {
        set.add(taskId);
      } else {
        set.remove(taskId);
      }
    });
    _saveProgress();
  }

  Future<void> _openTask(int moduleIndex, Map<String, dynamic> task) async {
    final taskType = task['type']?.toString() ?? '';
    final taskName = task['name']?.toString() ?? '';
    final courseTitle = widget.program['title']?.toString() ?? '';

    bool? completed;

    if (taskType == 'quiz') {
      completed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              QuizPage(quizTitle: taskName, courseTitle: courseTitle),
        ),
      );
    } else if (taskType == 'project') {
      completed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MiniProjectPage(projectTitle: taskName, courseTitle: courseTitle),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Palette.surface,
          title: Text(
            taskName,
            style: const TextStyle(color: Palette.textPrimary),
          ),
          content: const Text(
            'This is a reading assignment. Please complete the reading materials '
            'in your course portal, then mark this task as complete.',
            style: TextStyle(color: Palette.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Palette.primary),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    if (completed == true) {
      final taskId = 'm${moduleIndex}_$taskName';
      _toggleTask(moduleIndex, taskId, true);
    }
  }

  Widget _buildTaskTile(int moduleIndex, Map<String, dynamic> task) {
    final taskName = task['name']?.toString() ?? '';
    final taskType = task['type']?.toString() ?? '';
    final taskId = 'm${moduleIndex}_$taskName';
    final completed = _completedTasks[moduleIndex]!.contains(taskId);
    final locked = !_isModuleUnlocked(moduleIndex);

    IconData icon;
    Color iconColor;
    switch (taskType) {
      case 'quiz':
        icon = Icons.quiz;
        iconColor = completed ? Palette.success : Palette.primary;
        break;
      case 'project':
        icon = Icons.code;
        iconColor = completed ? Palette.success : Palette.secondary;
        break;
      case 'reading':
        icon = Icons.book;
        iconColor = completed ? Palette.success : Palette.primary;
        break;
      default:
        icon = Icons.task;
        iconColor = completed ? Palette.success : Palette.textTertiary;
    }

    return Opacity(
      opacity: locked ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: Palette.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            taskName,
            style: const TextStyle(
              color: Palette.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            taskType.toUpperCase(),
            style: const TextStyle(color: Palette.textTertiary, fontSize: 12),
          ),
          trailing: Checkbox(
            value: completed,
            activeColor: Palette.primary,
            onChanged: locked
                ? null
                : (v) {
                    _toggleTask(moduleIndex, taskId, v ?? false);
                  },
          ),
          onTap: locked ? null : () => _openTask(moduleIndex, task),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.program['title']?.toString() ?? 'Enrolled Course';

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: Text('$title - Learning Path'),
        backgroundColor: Palette.primary,
        foregroundColor: Palette.textOnPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress header with gradient background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: const BoxDecoration(gradient: Palette.primaryGradient),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Palette.textOnPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(_progress * 100).toStringAsFixed(0)}% complete • $_completedCount/$_totalTasks tasks',
                        style: TextStyle(
                          fontSize: 14,
                          color: Palette.textOnPrimary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: _progress,
                        backgroundColor: Palette.textOnPrimary.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Palette.textOnPrimary,
                        ),
                        strokeWidth: 6,
                      ),
                    ),
                    Text(
                      '${(_progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Palette.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ExpansionPanelList(
                  elevation: 1,
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      if (_isModuleUnlocked(index)) {
                        _isExpanded[index] = !isExpanded;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Complete previous module to unlock "${modules[index]['title']}"',
                            ),
                            backgroundColor: Palette.warning,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    });
                  },
                  children: List.generate(modules.length, (index) {
                    final module = modules[index];
                    final tasks = module['tasks'];
                    final taskList = (tasks is List) ? tasks : [];
                    final unlocked = _isModuleUnlocked(index);
                    final moduleCompleted =
                        (_completedTasks[index]?.length ?? 0) >=
                        taskList.length;

                    return ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: _isExpanded[index],
                      backgroundColor: Palette.surface,
                      headerBuilder: (context, isOpen) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: unlocked
                                    ? Palette.secondary
                                    : Palette.textTertiary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                module['week']?.toString() ?? '',
                                style: const TextStyle(
                                  color: Palette.textOnPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            title: Text(
                              module['title']?.toString() ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Palette.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              unlocked
                                  ? (moduleCompleted
                                        ? 'Completed ✓'
                                        : 'In Progress')
                                  : 'Locked',
                              style: TextStyle(
                                color: moduleCompleted
                                    ? Palette.success
                                    : Palette.textSecondary,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: unlocked
                                    ? Palette.containerLight
                                    : Palette.borderLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                unlocked ? Icons.lock_open : Icons.lock,
                                color: unlocked
                                    ? Palette.primary
                                    : Palette.textTertiary,
                                size: 16,
                              ),
                            ),
                          ),
                        );
                      },
                      body: Column(
                        children: [
                          ...taskList.map((t) {
                            if (t is Map) {
                              return _buildTaskTile(
                                index,
                                Map<String, dynamic>.from(t),
                              );
                            }
                            return const SizedBox.shrink();
                          }).toList(),
                          const Divider(color: Palette.borderLight),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow, size: 18),
                              label: const Text('Continue'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Palette.primary,
                                foregroundColor: Palette.textOnPrimary,
                                disabledBackgroundColor: Palette.textTertiary,
                              ),
                              onPressed: !unlocked
                                  ? null
                                  : () {
                                      setState(() {
                                        _isExpanded[index] = true;
                                      });
                                    },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Palette.surface,
                border: Border(
                  top: BorderSide(color: Palette.borderLight, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Palette.primary,
                        side: const BorderSide(color: Palette.primary),
                      ),
                      child: const Text('Back to Course'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.emoji_events),
                      label: const Text('Finish'),
                      onPressed: _progress >= 1.0
                          ? () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: Palette.surface,
                                  title: const Text(
                                    '🎉 Congratulations!',
                                    style: TextStyle(
                                      color: Palette.textPrimary,
                                    ),
                                  ),
                                  content: const Text(
                                    'You have completed this course! '
                                    'You will receive your certificate via email.',
                                    style: TextStyle(
                                      color: Palette.textSecondary,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Palette.primary,
                                      ),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        foregroundColor: Palette.textOnPrimary,
                        disabledBackgroundColor: Palette.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
