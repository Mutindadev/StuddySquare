import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/profile/data/models/profile_model.dart';

import '../provider/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> pickProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.profile.profilePicturePath = image.path;
      });
    }
  }

  Future<void> pickDailyGoal() async {
    final List<String> dailyGoals = [
      '30 minutes',
      '60 minutes',
      '90 minutes',
      '120 minutes',
    ];
    String? selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: dailyGoals
            .map(
              (goal) => ListTile(
                title: Text(goal),
                onTap: () => Navigator.pop(context, goal),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null) {
      widget.profile.dailyGoal = selected;
      setState(() {});
    }
  }

  Future<void> pickReminderTime() async {
    final TimeOfDay initialTime = _parseTime(widget.profile.reminderTime);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      widget.profile.reminderTime = picked.format(context);
      setState(() {});
    }
  }

  TimeOfDay _parseTime(String s) {
    final reg = RegExp(r'(\d{1,2}):(\d{2})\s*([AaPp][Mm])?');
    final m = reg.firstMatch(s);
    if (m != null) {
      int hour = int.tryParse(m.group(1)!) ?? 0;
      int minute = int.tryParse(m.group(2)!) ?? 0;
      final ampm = m.group(3);
      if (ampm != null) {
        final isPm = ampm.toLowerCase() == 'pm';
        if (isPm && hour < 12) hour += 12;
        if (!isPm && hour == 12) hour = 0;
      }
      hour = hour.clamp(0, 23);
      minute = minute.clamp(0, 59);
      return TimeOfDay(hour: hour, minute: minute);
    }
    return TimeOfDay.now();
  }

  void saveChanges() async {
    widget.profile.name = nameController.text.trim();
    widget.profile.email = emailController.text.trim();

    final provider = Provider.of<ProfileProvider>(context, listen: false);
    await provider.saveProfile(widget.profile);

    if (mounted) Navigator.pop(context, widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: widget.profile.profilePicturePath != null
                    ? FileImage(File(widget.profile.profilePicturePath!))
                    : null,
                child: widget.profile.profilePicturePath == null
                    ? Text(
                        widget.profile.name.substring(0, 2).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
                backgroundColor: const Color(0xFF6673FF),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text('Daily Goal'),
              subtitle: Text(widget.profile.dailyGoal),
              onTap: pickDailyGoal,
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Reminder Time'),
              subtitle: Text(widget.profile.reminderTime),
              onTap: pickReminderTime,
            ),
            const Divider(height: 1),
            SwitchListTile(
              title: const Text('Notifications'),
              value: widget.profile.notifications,
              onChanged: (v) =>
                  setState(() => widget.profile.notifications = v),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
