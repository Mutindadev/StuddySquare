import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studysquare/core/theme/palette.dart';
import 'package:studysquare/features/auth/presentation/provider/auth_provider.dart';
import 'package:studysquare/features/user/presentation/pages/registrationpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    const borderRadiusCard = BorderRadius.all(Radius.circular(12));
    const sectionPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Palette.surface,
        foregroundColor: Palette.textPrimary,
        elevation: 0.5,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Card
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Palette.cardBackground,
                    borderRadius: borderRadiusCard,
                    boxShadow: [
                      BoxShadow(
                        color: Palette.shadowLight,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          gradient: Palette.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'U1',
                            style: TextStyle(
                              color: Palette.textOnPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'User 1',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Palette.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'user1@gmail.com',
                              style: TextStyle(
                                color: Palette.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: 180,
                              child: Chip(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 0,
                                  ),
                                  child: Text(
                                    'Free',
                                    style: TextStyle(
                                      color: Palette.textOnPrimary,
                                    ),
                                  ),
                                ),
                                backgroundColor: Palette.secondary,
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
                        children: const [
                          SizedBox(height: 6),
                          Text(
                            'Member since',
                            style: TextStyle(
                              color: Palette.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'October\n2025',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              color: Palette.textSecondary,
                            ),
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
                      value: '3',
                    ),
                    const SizedBox(width: 10),
                    _smallStatCard(
                      icon: Icons.local_fire_department,
                      title: 'Streak',
                      value: '0 days',
                    ),
                    const SizedBox(width: 10),
                    _smallStatCard(
                      icon: Icons.emoji_events,
                      title: 'Total XP',
                      value: '0',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

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
                          value: notifications,
                          onChanged: (v) => setState(() => notifications = v),
                        ),
                      ),
                      const Divider(height: 1, color: Palette.borderLight),
                      _prefTile(
                        icon: Icons.track_changes,
                        title: 'Daily Goal',
                        subtitle: '60 minutes',
                        onTap: () {},
                      ),
                      const Divider(height: 1, color: Palette.borderLight),
                      _prefTile(
                        icon: Icons.access_time,
                        title: 'Reminder Time',
                        subtitle: '9:00 AM',
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
                              final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              );

                              await authProvider.signOut();

                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegistrationPage(),
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
          color: Palette.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Palette.containerLight,
              child: Icon(icon, color: Palette.primary, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Palette.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(color: Palette.textTertiary, fontSize: 12),
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
