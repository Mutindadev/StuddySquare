// ...existing code...
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/features/profile/data/models/profile_model.dart';

import '../provider/profile_provider.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // removed direct repo usage; use ProfileProvider instead

  @override
  Widget build(BuildContext context) {
    const borderRadiusCard = BorderRadius.all(Radius.circular(12));
    const sectionPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          if (profile != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updatedProfile = await Navigator.push<Profile?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(profile: profile),
                  ),
                );
                if (updatedProfile != null) {
                  await profileProvider.saveProfile(updatedProfile);
                }
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (profileProvider.isLoading && profile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (profile == null) {
              // show empty state with CTA to onboarding
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'No profile found',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/onboarding');
                        },
                        child: const Text('Create Profile'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadiusCard,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.remove_red_eye),
                                      title: const Text('View Photo'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        if (profile.profilePicturePath !=
                                            null) {
                                          showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              child: Image.file(
                                                File(
                                                  profile.profilePicturePath!,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_camera),
                                      title: const Text('Change Photo'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        final ImagePicker picker =
                                            ImagePicker();
                                        final pickedFile = await picker
                                            .pickImage(
                                              source: ImageSource.gallery,
                                            );
                                        if (pickedFile != null) {
                                          profile.profilePicturePath =
                                              pickedFile.path;
                                          await profileProvider.updateProfile(
                                            profile,
                                          );
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Delete Photo'),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        profile.profilePicturePath = null;
                                        await profileProvider.updateProfile(
                                          profile,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  profile.profilePicturePath != null
                                  ? FileImage(File(profile.profilePicturePath!))
                                  : null,
                              child: profile.profilePicturePath == null
                                  ? Text(
                                      profile.name
                                          .substring(0, 2)
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : null,
                              backgroundColor: const Color(0xFF6673FF),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  profile.email,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 120,
                                  child: Chip(
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Text(
                                        profile.plan,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    backgroundColor: const Color(0xFFFB8C00),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 6),
                              const Text(
                                'Member since',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                profile.membershipDate,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _smallStatCard(
                          icon: Icons.school,
                          title: 'Courses',
                          value: '${profile.courses}',
                        ),
                        const SizedBox(width: 10),
                        _smallStatCard(
                          icon: Icons.local_fire_department,
                          title: 'Streak',
                          value: '${profile.streak} days',
                        ),
                        const SizedBox(width: 10),
                        _smallStatCard(
                          icon: Icons.emoji_events,
                          title: 'Total XP',
                          value: '${profile.totalXP}',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferences',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.notifications_none),
                          title: const Text('Notifications'),
                          trailing: Switch(
                            value: profile.notifications,
                            onChanged: (v) async {
                              profile.notifications = v;
                              await profileProvider.updateProfile(profile);
                            },
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.track_changes),
                          title: const Text('Daily Goal'),
                          subtitle: Text(profile.dailyGoal),
                        ),
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: const Text('Reminder Time'),
                          subtitle: Text(profile.reminderTime),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _smallStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFEEF2FF),
              child: Icon(icon, color: const Color(0xFF6673FF), size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
// ...existing code...