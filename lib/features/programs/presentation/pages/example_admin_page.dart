import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/presentation/provider/program_admin_provider.dart';

/// Example Admin Page for creating user programs
/// This is a reference implementation showing how to use ProgramAdminProvider
/// to create programs at runtime.
/// 
/// To integrate this into the app:
/// 1. Add navigation to this page from the main menu (for admin users)
/// 2. Add proper validation for all fields
/// 3. Enhance UI with better styling matching app theme
/// 4. Add module/task builder for complex programs
class ExampleAdminPage extends StatefulWidget {
  const ExampleAdminPage({super.key});

  @override
  State<ExampleAdminPage> createState() => _ExampleAdminPageState();
}

class _ExampleAdminPageState extends State<ExampleAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedLevel = 'Beginner';
  final List<String> _learningOutcomes = [];
  final _outcomeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _outcomeController.dispose();
    super.dispose();
  }

  void _addLearningOutcome() {
    if (_outcomeController.text.isNotEmpty) {
      setState(() {
        _learningOutcomes.add(_outcomeController.text);
        _outcomeController.clear();
      });
    }
  }

  void _removeLearningOutcome(int index) {
    setState(() {
      _learningOutcomes.removeAt(index);
    });
  }

  Future<void> _saveProgram() async {
    if (_formKey.currentState!.validate()) {
      // Generate a unique ID
      final programId = 'user_prog_${DateTime.now().millisecondsSinceEpoch}';

      // Create a basic program with one module
      final program = Program(
        id: programId,
        title: _titleController.text,
        description: _descriptionController.text,
        duration: _durationController.text,
        level: _selectedLevel,
        learning: _learningOutcomes,
        modules: [
          Module(
            week: 'Week 1',
            title: 'Introduction',
            tasks: [
              Task(
                name: 'Getting Started',
                type: TaskType.reading,
              ),
            ],
          ),
        ],
      );

      // Save using ProgramAdminProvider
      final adminProvider = context.read<ProgramAdminProvider>();
      await adminProvider.addProgram(program);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Program created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Program'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProgram,
            tooltip: 'Save Program',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Program Title',
                hintText: 'e.g., Advanced Python Programming',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description of the program',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Duration Field
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration',
                hintText: 'e.g., 4 weeks, 8 weeks',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter duration';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Level Dropdown
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              decoration: const InputDecoration(
                labelText: 'Level',
                border: OutlineInputBorder(),
              ),
              items: ['Beginner', 'Intermediate', 'Advanced']
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            // Learning Outcomes Section
            const Text(
              'Learning Outcomes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _outcomeController,
                    decoration: const InputDecoration(
                      hintText: 'Add a learning outcome',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addLearningOutcome(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addLearningOutcome,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List of Learning Outcomes
            if (_learningOutcomes.isNotEmpty)
              Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _learningOutcomes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.check_circle_outline),
                      title: Text(_learningOutcomes[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeLearningOutcome(index),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 24),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveProgram,
              icon: const Icon(Icons.save),
              label: const Text('Create Program'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of how to navigate to the admin page
void navigateToAdminPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ExampleAdminPage(),
    ),
  );
}

/// Example of viewing user-created programs
class UserProgramsListPage extends StatelessWidget {
  const UserProgramsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Programs'),
      ),
      body: Consumer<ProgramAdminProvider>(
        builder: (context, adminProvider, _) {
          final userPrograms = adminProvider.userPrograms;

          if (userPrograms.isEmpty) {
            return const Center(
              child: Text('No custom programs created yet'),
            );
          }

          return ListView.builder(
            itemCount: userPrograms.length,
            itemBuilder: (context, index) {
              final program = userPrograms[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(program.title),
                  subtitle: Text(program.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await adminProvider.removeProgram(program.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Program deleted'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAdminPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
