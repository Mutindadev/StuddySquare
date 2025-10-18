import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_page.dart';
import 'mini_project_page.dart';

// StudySquare official colors from Figma design
const Color primaryBlue = Color(0xFF2B7FFF); // #2B7FFF
const Color primaryPurple = Color(0xFF9810FA); // #9810FA
const Color backgroundLight = Color(0xFFF9FAFB);
const Color cardWhite = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF1A1A1A);
const Color textGray = Color(0xFF64748B);

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
          ]
        }
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
          builder: (_) => QuizPage(
            quizTitle: taskName,
            courseTitle: courseTitle,
          ),
        ),
      );
    } else if (taskType == 'project') {
      completed = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MiniProjectPage(
            projectTitle: taskName,
            courseTitle: courseTitle,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(taskName),
          content: const Text(
            'This is a reading assignment. Please complete the reading materials '
            'in your course portal, then mark this task as complete.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
        iconColor = completed ? Colors.green : primaryBlue;
        break;
      case 'project':
        icon = Icons.code;
        iconColor = completed ? Colors.green : primaryPurple;
        break;
      case 'reading':
        icon = Icons.book;
        iconColor = completed ? Colors.green : primaryBlue;
        break;
      default:
        icon = Icons.task;
        iconColor = completed ? Colors.green : textGray;
    }

    return Opacity(
      opacity: locked ? 0.5 : 1.0,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(taskName, style: TextStyle(color: textDark)),
        subtitle: Text(
          taskType.toUpperCase(),
          style: TextStyle(color: textGray, fontSize: 12),
        ),
        trailing: Checkbox(
          value: completed,
          activeColor: primaryPurple,
          onChanged: locked
              ? null
              : (v) {
                  _toggleTask(moduleIndex, taskId, v ?? false);
                },
        ),
        onTap: locked ? null : () => _openTask(moduleIndex, task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.program['title']?.toString() ?? 'Enrolled Course';

    return Scaffold(
      appBar: AppBar(
        title: Text('$title - Learning Path'),
        backgroundColor: primaryPurple, // Purple AppBar
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress header with gradient background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF3E5FD), Color(0xFFE1BEFA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(_progress * 100).toStringAsFixed(0)}% complete • $_completedCount/$_totalTasks tasks',
                        style: TextStyle(fontSize: 14, color: textGray),
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
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            primaryPurple), // Purple progress
                        strokeWidth: 6,
                      ),
                    ),
                    Text(
                      '${(_progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textDark,
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
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      if (_isModuleUnlocked(index)) {
                        _isExpanded[index] = !isExpanded;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Complete previous module to unlock "${modules[index]['title']}"'),
                          duration: const Duration(seconds: 2),
                        ));
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
                      headerBuilder: (context, isOpen) {
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: unlocked
                                  ? primaryPurple
                                  : Colors.grey, // Purple badge when unlocked
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              module['week']?.toString() ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(
                            module['title']?.toString() ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          subtitle: Text(
                            unlocked
                                ? (moduleCompleted
                                    ? 'Completed ✓'
                                    : 'In Progress')
                                : 'Locked',
                            style: TextStyle(
                              color: moduleCompleted ? Colors.green : textGray,
                            ),
                          ),
                          trailing: Icon(
                            unlocked ? Icons.lock_open : Icons.lock,
                            color: unlocked ? primaryPurple : Colors.grey,
                          ),
                        );
                      },
                      body: Column(
                        children: [
                          ...taskList.map((t) {
                            if (t is Map) {
                              return _buildTaskTile(
                                  index, Map<String, dynamic>.from(t));
                            }
                            return const SizedBox.shrink();
                          }).toList(),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow, size: 18),
                              label: const Text('Continue'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryPurple, // Purple button
                                foregroundColor: Colors.white,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryPurple,
                        side: BorderSide(color: primaryPurple),
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
                                  title: const Text('🎉 Congratulations!'),
                                  content: const Text(
                                    'You have completed this course! '
                                    'You will receive your certificate via email.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryPurple,
                                      ),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple, // Purple finish button
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
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
