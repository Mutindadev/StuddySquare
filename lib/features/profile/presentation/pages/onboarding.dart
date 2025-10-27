import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/home/presentation/pages/home.dart';
import 'package:studysquare/features/profile/data/models/profile_model.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dailyGoalCtrl = TextEditingController(text: '60 minutes');
  final _reminderCtrl = TextEditingController(text: '09:00 AM');
  String _plan = 'Free';
  bool _notifications = true;
  int _courses = 0;
  String? _profileImagePath;

  final ImagePicker _picker = ImagePicker();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dailyGoalCtrl.dispose();
    _reminderCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) setState(() => _profileImagePath = file.path);
    } on MissingPluginException {
      // plugin not registered (usually requires full restart/rebuild)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Image picker not available. Stop the app and run flutter run to rebuild.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not pick image: $e')));
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _submitting = true);

    final now = DateTime.now();
    final membershipDate = '${_monthName(now.month)} ${now.year}';

    final profile = Profile(
      // id: FirebaseAuth.instance.currentUser?.uid ?? '',
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      membershipDate: membershipDate,
      plan: _plan,
      courses: _courses,
      streak: 0,
      totalXP: 0,
      notifications: _notifications,
      dailyGoal: _dailyGoalCtrl.text.trim(),
      reminderTime: _reminderCtrl.text.trim(),
      profilePicturePath: _profileImagePath,
    );

    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await provider.saveProfile(profile);
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } catch (e) {
      // simple error feedback
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _monthName(int m) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // header card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6673FF), Color(0xFF9A8CFF)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.white24,
                            backgroundImage: _profileImagePath != null
                                ? FileImage(File(_profileImagePath!))
                                : null,
                            child: _profileImagePath == null
                                ? const Icon(
                                    Icons.person,
                                    size: 34,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Color(0xFF6673FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create your profile',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Personalize StudySquare to track your progress and get reminders.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      _nameCtrl,
                      'Full name',
                      Icons.person,
                      (v) => (v == null || v.trim().isEmpty)
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      _emailCtrl,
                      'Email',
                      Icons.email,
                      (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Please enter email';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim()))
                          return 'Invalid email';
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    // plan + courses row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _plan,
                            decoration: _inputDecoration(
                              'Plan',
                              const Icon(Icons.workspace_premium),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Free',
                                child: Text('Free'),
                              ),
                              DropdownMenuItem(
                                value: 'Pro',
                                child: Text('Pro'),
                              ),
                              DropdownMenuItem(
                                value: 'Enterprise',
                                child: Text('Enterprise'),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _plan = v ?? 'Free'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 110,
                          child: TextFormField(
                            initialValue: '0',
                            decoration: _inputDecoration(
                              'Courses',
                              const Icon(Icons.school),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => _courses = int.tryParse(v) ?? 0,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dailyGoalCtrl,
                      decoration: _inputDecoration(
                        'Daily Goal',
                        const Icon(Icons.track_changes),
                      ).copyWith(hintText: 'e.g. 60 minutes'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _reminderCtrl,
                      decoration: _inputDecoration(
                        'Reminder Time',
                        const Icon(Icons.access_time),
                      ).copyWith(hintText: 'e.g. 09:00 AM'),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      value: _notifications,
                      onChanged: (v) => setState(() => _notifications = v),
                      title: const Text('Enable notifications'),
                      contentPadding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 18),
                    // modern submit button with gradient and loading state
                    InkWell(
                      onTap: _submitting ? null : _submit,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: _submitting
                              ? LinearGradient(
                                  colors: [
                                    Colors.grey.shade400,
                                    Colors.grey.shade500,
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFF6673FF),
                                    Color(0xFF9A8CFF),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _submitting
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: _submitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, Icon icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    String? Function(String?)? validator, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, Icon(icon)),
    );
  }
}
