import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_page.dart';
import 'mini_project_page.dart';

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
    switch (taskType) {
      case 'quiz':
        icon = Icons.quiz;
        break;
      case 'project':
        icon = Icons.code;
        break;
      case 'reading':
        icon = Icons.book;
        break;
      default:
        icon = Icons.task;
    }

    return Opacity(
      opacity: locked ? 0.5 : 1.0,
      child: ListTile(
        leading: Icon(icon, color: completed ? Colors.green : Colors.grey),
        title: Text(taskName),
        subtitle: Text(taskType.toUpperCase()),
        trailing: Checkbox(
          value: completed,
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
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            color: Colors.red.shade50,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(_progress * 100).toStringAsFixed(0)}% complete • $_completedCount/$_totalTasks tasks',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
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
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.red),
                        strokeWidth: 6,
                      ),
                    ),
                    Text(
                      '${(_progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                              color: unlocked ? Colors.red : Colors.grey,
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            unlocked
                                ? (moduleCompleted
                                    ? 'Completed ✓'
                                    : 'In Progress')
                                : 'Locked',
                          ),
                          trailing:
                              Icon(unlocked ? Icons.lock_open : Icons.lock),
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
                                backgroundColor: Colors.red,
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
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
