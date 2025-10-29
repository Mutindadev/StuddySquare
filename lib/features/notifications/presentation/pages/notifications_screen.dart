import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:studysquare/core/theme/palette.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId; // e.g. "u1", "u2", "a1"
  final ValueChanged<int>? onUnreadCountChanged; // callback to update dashboard badge
  const NotificationsScreen({super.key, required this.userId, this.onUnreadCountChanged});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic>? userNotifications;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadNotificationsJson();
  }

  Future<void> loadNotificationsJson() async {
    try {
      final rawData = await rootBundle.loadString('assets/data/notifications.json');
      final jsonData = json.decode(rawData) as Map<String, dynamic>;
      final allNotifications = jsonData['notifications'] as List<dynamic>;

      final filtered = allNotifications
          .where((n) => n['userId']?.toString().toLowerCase() == widget.userId.toLowerCase())
          .toList();

      filtered.sort((a, b) =>
          DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));

      _updateUnreadCount(filtered);

      setState(() {
        userNotifications = filtered;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load notifications: $e';
        isLoading = false;
      });
    }
  }

  void _updateUnreadCount(List<dynamic> notifications) {
    final unread = notifications.where((n) => n['isRead'] == false).length;
    widget.onUnreadCountChanged?.call(unread);
  }

  void _markAsRead(int index) {
    setState(() {
      userNotifications![index]['isRead'] = true;
      _updateUnreadCount(userNotifications!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        backgroundColor: Palette.surface,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Palette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Palette.primary),
      ),
      body: userNotifications == null || userNotifications!.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet.',
                style: TextStyle(color: Palette.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userNotifications!.length,
              itemBuilder: (context, index) {
                final n = userNotifications![index];
                final isRead = n['isRead'] ?? false;
                final time = DateTime.parse(n['timestamp']);
                final formattedDate =
                    '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}  ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

                return GestureDetector(
                  onTap: () => _markAsRead(index),
                  child: _buildNotificationCard(
                    title: n['title'] ?? 'Notification',
                    message: n['message'] ?? '',
                    isRead: isRead,
                    timestamp: formattedDate,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required bool isRead,
    required String timestamp,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Palette.surface : Palette.containerLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Palette.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isRead ? Icons.notifications_none : Icons.notifications_active_outlined,
            color: isRead ? Palette.textSecondary : Palette.primary,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                    color: Palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14, color: Palette.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  timestamp,
                  style: const TextStyle(fontSize: 12, color: Palette.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
