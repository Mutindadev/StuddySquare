// ...existing code...
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/auth/presentation/provider/auth_provider.dart';
import 'package:studysquare/features/profile/data/models/profile_model.dart';
import 'package:studysquare/features/user/presentation/pages/landing_page.dart';

import '../provider/profile_provider.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _stats = {};
  // removed direct repo usage; use ProfileProvider instead
  bool notifications = true;

  @override
  void initState() {
    _loadStats();

    super.initState();
  }

  Future<void> _loadStats() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final stats = await profileProvider.getOverallStats();
    if (mounted) {
      setState(() {
        _stats = stats;
      });
    }
  }

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
                          value: '${profile.enrolledCourses?.length}',
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
                          value: "${_stats['total_xp'] ?? 0}",
                        ),
                      ],
                    ),
                  ),

                  // Preferences
                  Padding(
                    padding: sectionPadding,
                    child: const Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Palette.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.surface,
                        borderRadius: borderRadiusCard,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.notifications_none,
                              color: Palette.textSecondary,
                            ),
                            title: const Text(
                              'Notifications',
                              style: TextStyle(color: Palette.textPrimary),
                            ),
                            trailing: Switch(
                              value: profile.notifications,
                              onChanged: (v) async {
                                profile.notifications = v;
                                await profileProvider.updateProfile(profile);
                              },
                            ),
                          ),
                          const Divider(height: 1, color: Palette.borderLight),
                          _prefTile(
                            icon: Icons.track_changes,
                            title: 'Daily Goal',
                            subtitle: profile.dailyGoal,
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: Palette.borderLight),
                          _prefTile(
                            icon: Icons.access_time,
                            title: 'Reminder Time',
                            subtitle: profile.reminderTime,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Account section
                  Padding(
                    padding: sectionPadding,
                    child: const Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Palette.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.surface,
                        borderRadius: borderRadiusCard,
                      ),
                      child: Column(
                        children: [
                          _prefTile(
                            icon: Icons.settings_outlined,
                            title: 'Account settings',
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: Palette.borderLight),
                          _prefTile(
                            icon: Icons.lock_outline,
                            title: 'Privacy & Security',
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: Palette.borderLight),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () async {
                                  // Use the correct provider
                                  final authProvider =
                                      Provider.of<AuthProvider>(
                                        context,
                                        listen: false,
                                      );

                                  await authProvider.signOut();

                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LandingPage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Palette.error,
                                  side: const BorderSide(color: Palette.error),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text('Sign out'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Footer
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'Study sphere v1.0.0',
                          style: TextStyle(
                            color: Palette.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '© 2025 ALL rights reserved',
                          style: TextStyle(
                            color: Palette.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 12),
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

  Widget _prefTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Palette.surfaceVariant,
        radius: 18,
        child: Icon(icon, color: Palette.textSecondary, size: 18),
      ),
      title: Text(title, style: const TextStyle(color: Palette.textPrimary)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: Palette.textTertiary, fontSize: 12),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: Palette.textTertiary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
// ...existing code...