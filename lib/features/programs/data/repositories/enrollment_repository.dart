import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing user enrollment data using SharedPreferences.
/// Stores enrollment data per user (identified by uid).
class EnrollmentRepository {
  static const String _keyPrefix = 'enrollments_';

  /// Gets the set of enrolled program IDs for a specific user.
  Future<Set<String>> getEnrollments(String uid) async {
    if (uid.isEmpty) return {};
    
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$uid';
    final json = prefs.getString(key);
    
    if (json == null) return {};
    
    try {
      final List<dynamic> list = jsonDecode(json);
      return Set<String>.from(list);
    } catch (e) {
      return {};
    }
  }

  /// Saves the set of enrolled program IDs for a specific user.
  Future<void> saveEnrollments(String uid, Set<String> enrolledIds) async {
    if (uid.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$uid';
    final json = jsonEncode(enrolledIds.toList());
    await prefs.setString(key, json);
  }

  /// Clears all enrollment data for a specific user.
  Future<void> clearEnrollments(String uid) async {
    if (uid.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$uid';
    await prefs.remove(key);
  }
}
