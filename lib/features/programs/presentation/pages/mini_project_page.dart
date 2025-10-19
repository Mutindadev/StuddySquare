import 'package:flutter/material.dart';

class MiniProjectPage extends StatefulWidget {
  final String projectTitle;
  final String courseTitle;

  const MiniProjectPage({
    Key? key,
    required this.projectTitle,
    required this.courseTitle,
  }) : super(key: key);

  @override
  State<MiniProjectPage> createState() => _MiniProjectPageState();
}

class _MiniProjectPageState extends State<MiniProjectPage> {
  final TextEditingController _submissionController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _submissionController.dispose();
    super.dispose();
  }

  void _submitProject() {
    if (_submissionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your submission first')),
      );
      return;
    }

    setState(() {
      _submitted = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Project Submitted!'),
        content: const Text(
          'Your project has been submitted successfully. '
          'You will receive feedback within 48 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true); // Return to course with completion
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectTitle),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project brief
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.assignment, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'Project Brief',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'In this mini-project, you will apply the concepts you\'ve learned '
                      'to solve a real-world problem. Follow the instructions below and '
                      'submit your solution.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Requirements
            const Text(
              'Requirements:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildRequirement('Complete all tasks outlined in the brief'),
            _buildRequirement('Document your approach and findings'),
            _buildRequirement('Test your solution thoroughly'),
            _buildRequirement('Submit your work via the form below'),
            const SizedBox(height: 24),

            // Resources
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.lightbulb, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Helpful Resources',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('• Review module materials'),
                    const Text('• Check the discussion forum'),
                    const Text('• Refer to code examples'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submission area
            const Text(
              'Your Submission:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _submissionController,
              maxLines: 8,
              enabled: !_submitted,
              decoration: InputDecoration(
                hintText:
                    'Describe your solution, paste code, or provide a link to your work...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: _submitted ? Colors.grey.shade100 : Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _submitted ? null : _submitProject,
                icon: Icon(_submitted ? Icons.check_circle : Icons.upload),
                label: Text(_submitted ? 'Submitted' : 'Submit Project'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (_submitted) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Project submitted! Check back for feedback.',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_box, size: 20, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
