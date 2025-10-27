import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/presentation/provider/program_admin_provider.dart';

import 'outline_editor_page.dart';

class AdminProgramsPage extends StatefulWidget {
  const AdminProgramsPage({super.key});

  @override
  State<AdminProgramsPage> createState() => _AdminProgramsPageState();
}

class _AdminProgramsPageState extends State<AdminProgramsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(text: '6 weeks');
  String _level = 'Intermediate';
  final _learningCtrl = TextEditingController();
  final List<String> _learning = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _durationCtrl.dispose();
    _learningCtrl.dispose();
    super.dispose();
  }

  Future<void> _addProgram(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final program = Program(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      duration: _durationCtrl.text.trim(),
      level: _level,
      learning: List<String>.from(_learning),
      modules: const [
        Module(
          week: 'Week 1-2',
          title: 'Intro',
          tasks: [
            Task(name: 'Intro: Reading', type: TaskType.reading),
          ],
        ),
      ],
    );

    await context.read<ProgramAdminProvider>().addProgram(program);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Program added')), 
    );
    _titleCtrl.clear();
    _descCtrl.clear();
    _learning
      ..clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<ProgramAdminProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin — Programs'),
        backgroundColor: Palette.primary,
        foregroundColor: Palette.textOnPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: 'Short Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _level,
                  decoration: const InputDecoration(labelText: 'Level'),
                  items: const ['Beginner', 'Intermediate', 'Advanced']
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) => setState(() => _level = v ?? 'Intermediate'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _durationCtrl,
                  decoration: const InputDecoration(labelText: 'Duration (e.g. 6 weeks)'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _learningCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Learning outcome',
                          hintText: 'Add outcome and press +',
                        ),
                        onSubmitted: (_) {
                          if (_learningCtrl.text.trim().isNotEmpty) {
                            setState(() {
                              _learning.add(_learningCtrl.text.trim());
                              _learningCtrl.clear();
                            });
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (_learningCtrl.text.trim().isNotEmpty) {
                          setState(() {
                            _learning.add(_learningCtrl.text.trim());
                            _learningCtrl.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                if (_learning.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _learning
                          .asMap()
                          .entries
                          .map(
                            (e) => Chip(
                              label: Text(e.value),
                              onDeleted: () {
                                setState(() => _learning.removeAt(e.key));
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _addProgram(context),
                      child: const Text('Add Program'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => context.read<ProgramAdminProvider>().clearUserPrograms(),
                      child: const Text('Clear All (local)'),
                    ),
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: admin.userPrograms.isEmpty
                  ? const Center(child: Text('No admin programs yet'))
                  : ListView.builder(
                      itemCount: admin.userPrograms.length,
                      itemBuilder: (_, idx) {
                        final p = admin.userPrograms[idx];
                        return Card(
                          child: ListTile(
                            title: Text(p.title),
                            subtitle: Text(p.description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Edit outline',
                                  icon: const Icon(Icons.account_tree_outlined),
                                  onPressed: () async {
                                    final updated = await Navigator.push<List<Module>>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => OutlineEditorPage(
                                          programId: p.id,
                                          initialModules: List<Module>.from(p.modules),
                                        ),
                                      ),
                                    );
                                    if (updated != null) {
                                      final updatedProgram = p.copyWith(modules: updated);
                                      await context.read<ProgramAdminProvider>().updateProgram(updatedProgram);
                                    }
                                  },
                                ),
                                IconButton(
                                  tooltip: 'Edit basic fields',
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _openEditDialog(context, p),
                                ),
                                IconButton(
                                  tooltip: 'Delete',
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () async {
                                    final ok = await _confirm(context, 'Delete this program?');
                                    if (ok) {
                                      await context.read<ProgramAdminProvider>().removeProgram(p.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditDialog(BuildContext context, Program p) async {
    final title = TextEditingController(text: p.title);
    final desc = TextEditingController(text: p.description);
    final duration = TextEditingController(text: p.duration);
    String level = p.level;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Program'),
        content: SizedBox(
          width: 420,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')), 
            TextField(controller: desc, decoration: const InputDecoration(labelText: 'Description')), 
            DropdownButtonFormField<String>(
              value: level,
              items: const ['Beginner', 'Intermediate', 'Advanced']
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (v) => level = v ?? p.level,
              decoration: const InputDecoration(labelText: 'Level'),
            ),
            TextField(controller: duration, decoration: const InputDecoration(labelText: 'Duration')), 
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), 
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')), 
        ],
      ),
    );

    if (ok == true && context.mounted) {
      final updated = p.copyWith(
        title: title.text.trim(),
        description: desc.text.trim(),
        level: level,
        duration: duration.text.trim(),
      );
      await context.read<ProgramAdminProvider>().updateProgram(updated);
    }
  }

  Future<bool> _confirm(BuildContext context, String text) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(text),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')), 
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')), 
        ],
      ),
    );
    return ok == true;
  }
}