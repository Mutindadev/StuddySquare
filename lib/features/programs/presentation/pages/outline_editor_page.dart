import 'package:flutter/material.dart';
import 'package:studysquare/features/programs/data/models/program.dart';

class OutlineEditorPage extends StatefulWidget {
  final String programId;
  final List<Module> initialModules;
  const OutlineEditorPage({super.key, required this.programId, required this.initialModules});

  @override
  State<OutlineEditorPage> createState() => _OutlineEditorPageState();
}

class _OutlineEditorPageState extends State<OutlineEditorPage> {
  late List<Module> _sections;

  @override
  void initState() {
    super.initState();
    _sections = widget.initialModules.map((m) => m.copyWith()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Outline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => Navigator.pop(context, _sections),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _sections.length,
        itemBuilder: (_, idx) {
          final section = _sections[idx];
          final labelCtrl = TextEditingController(text: section.week);
          final titleCtrl = TextEditingController(text: section.title);

          return Card(
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(section.week),
              subtitle: Text(section.title),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => setState(() => _sections.removeAt(idx)),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(children: [
                    TextField(controller: labelCtrl, decoration: const InputDecoration(labelText: 'Week label')),
                    TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Section title')),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            final tasks = List<Task>.from(section.tasks);
                            tasks.add(const Task(name: 'New Task', type: TaskType.reading));
                            _sections[idx] = section.copyWith(tasks: tasks);
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Task'),
                      ),
                    ),
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) {
                        final tasks = List<Task>.from(section.tasks);
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = tasks.removeAt(oldIndex);
                        tasks.insert(newIndex, item);
                        setState(() => _sections[idx] = section.copyWith(tasks: tasks));
                      },
                      itemCount: section.tasks.length,
                      itemBuilder: (_, tIdx) {
                        final tasks = List<Task>.from(section.tasks);
                        final task = tasks[tIdx];
                        final tTitle = TextEditingController(text: task.name);
                        final tType = TextEditingController(text: task.type.value.toUpperCase());

                        return ListTile(
                          key: ValueKey('task_${idx}_$tIdx'),
                          title: TextField(
                            controller: tTitle,
                            decoration: const InputDecoration(labelText: 'Task title'),
                            onChanged: (v) {
                              tasks[tIdx] = task.copyWith(name: v);
                              setState(() => _sections[idx] = section.copyWith(tasks: tasks));
                            },
                          ),
                          subtitle: TextField(
                            controller: tType,
                            decoration: const InputDecoration(labelText: 'Type (READING/QUIZ/PROJECT)'),
                            onChanged: (v) {
                              final type = TaskType.fromString(v.toLowerCase());
                              tasks[tIdx] = task.copyWith(type: type);
                              setState(() => _sections[idx] = section.copyWith(tasks: tasks));
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              tasks.removeAt(tIdx);
                              setState(() => _sections[idx] = section.copyWith(tasks: tasks));
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          final updated = section.copyWith(
                            week: labelCtrl.text.trim(),
                            title: titleCtrl.text.trim(),
                          );
                          setState(() => _sections[idx] = updated);
                        },
                        child: const Text('Save Section Changes'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ]),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _sections.add(
              const Module(
                week: 'Week',
                title: 'New Section',
                tasks: [Task(name: 'New Task', type: TaskType.reading)],
              ),
            );
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Section'),
      ),
    );
  }
}
