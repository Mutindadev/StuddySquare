// ...existing code...
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studysquare/features/auth/presentation/provider/auth_provider.dart';
import 'package:studysquare/features/profile/data/models/profile_model.dart';
import 'package:studysquare/features/profile/data/repositories/profile_repository.dart';
import 'package:studysquare/features/programs/data/services/program_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();
  AuthProvider? _authProvider;

  Profile? _profile;
  bool _loading = true; // Start loading initially

  Profile? get profile => _profile;
  bool get isLoading => _loading;

  ProfileProvider(AuthProvider? auth) {
    _authProvider = auth;
    _loadInitialProfile();
  }

  void _loadInitialProfile() {
    final user = _authProvider?.user;
    if (user != null) {
      loadProfileById(user.uid);
    } else {
      _loading = false; // Not logged in, so not loading
    }
  }

  // Called by main.dart when AuthProvider changes
  void updateAuth(AuthProvider auth) {
    // Check if the user has changed (logged in or out)
    if (_authProvider?.user?.uid != auth.user?.uid) {
      _authProvider = auth;
      final user = auth.user;

      if (user != null) {
        // User just logged in
        loadProfileById(user.uid);
      } else {
        // User just logged out
        clearLocalProfile();
      }
    }
  }

  Future<void> loadProfileById(String id) async {
    if (id.isEmpty) {
      _profile = null;
      _loading = false;
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    try {
      final p = await _repo.getProfileById(id);
      _profile = p;
    } catch (e) {
      debugPrint("Error loading profile: $e");
      _profile = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(Profile p) async {
    _loading = true;
    notifyListeners();
    await _repo.saveProfile(p); // saveProfile will add or replace existing
    _profile = p;
    _loading = false;
    notifyListeners();
  }

  Future<void> updateProfile(Profile p) async {
    await saveProfile(p);
  }

  Future<void> deleteProfile(String email) async {
    _loading = true;
    notifyListeners();
    await _repo.deleteProfileByEmail(email);
    _profile = null;
    _loading = false;
    notifyListeners();
  }

  void clearLocalProfile() {
    _profile = null;
    _loading = false; // User is logged out, so we are not loading
    notifyListeners();
  }

  Future<void> enrollInCourse(String programId) async {
    if (_profile == null) return;

    final currentCourses = _profile!.enrolledCourses ?? [];
    if (!currentCourses.contains(programId)) {
      _profile!.enrolledCourses = [...currentCourses, programId];
      await saveProfile(_profile!);
    }
  }

  Future<void> unenrollFromCourse(String programId) async {
    if (_profile == null) return;

    final currentCourses = _profile!.enrolledCourses ?? [];
    if (currentCourses.contains(programId)) {
      _profile!.enrolledCourses = currentCourses
          .where((id) => id != programId)
          .toList();
      await saveProfile(_profile!);
    }
  }

  bool isEnrolledInCourse(String programId) {
    if (_profile?.enrolledCourses == null) return false;
    return _profile!.enrolledCourses!.contains(programId);
  }

  // Get progress for a specific course
  Future<double> getCourseProgress(String programId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'progress_${programId}';
    final saved = prefs.getString(key);

    if (saved != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(saved);
        int totalCompleted = 0;
        int totalTasks = 0;

        data.forEach((_, taskList) {
          if (taskList is List) {
            totalCompleted += taskList.length;
          }
        });

        // Get program to find total tasks
        final program = await ProgramService.getProgramById(programId);
        if (program != null) {
          totalTasks = program.totalTasks;
          return totalTasks > 0 ? totalCompleted / totalTasks : 0.0;
        }
      } catch (e) {
        debugPrint('Error calculating progress: $e');
      }
    }
    return 0.0;
  }

  // Get overall progress across all enrolled courses
  Future<Map<String, double>> getAllCoursesProgress() async {
    final Map<String, double> progress = {};

    if (_profile?.enrolledCourses != null) {
      for (final programId in _profile!.enrolledCourses!) {
        progress[programId] = await getCourseProgress(programId);
      }
    }

    return progress;
  }

  Future<Map<String, dynamic>> getOverallStats() async {
    int totalCompletedTasks = 0;
    double totalHoursLearned = 0;

    // Get progress for each enrolled course from SharedPreferences
    if (_profile?.enrolledCourses != null) {
      for (final programId in _profile!.enrolledCourses!) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final key = 'progress_${programId}';
          final saved = prefs.getString(key);
          debugPrint('Loading progress for $programId: $saved'); // Debug print

          if (saved != null) {
            final Map<String, dynamic> data = jsonDecode(saved);
            // Count completed tasks in each module
            data.forEach((moduleIndex, taskList) {
              if (taskList is List) {
                totalCompletedTasks += taskList.length;
                // Calculate hours (30 mins per task)
                totalHoursLearned += (taskList.length * 0.5);
              }
            });
          }
        } catch (e) {
          debugPrint('Error calculating stats for program $programId: $e');
        }
      }
    }

    // Calculate total XP (100 per completed task)
    final totalXP = totalCompletedTasks * 100;

    debugPrint('Stats calculated:'); // Debug prints
    debugPrint('Total tasks completed: $totalCompletedTasks');
    debugPrint('Total hours learned: $totalHoursLearned');
    debugPrint('Total XP: $totalXP');

    return {
      'total_xp': totalXP,
      'courses_enrolled': _profile?.enrolledCourses?.length ?? 0,
      'day_streak': _profile?.streak ?? 0,
      'lessons_done': totalCompletedTasks, // Use actual completed tasks count
      'hours_learned': totalHoursLearned.round(),
    };
  }

  // Add this debug helper
  Future<void> debugPrintAllProgress() async {
    if (_profile?.enrolledCourses == null) {
      debugPrint('No enrolled courses');
      return;
    }

    for (final programId in _profile!.enrolledCourses!) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'progress_${programId}';
      final saved = prefs.getString(key);
      debugPrint('Progress for $programId: $saved');
    }
  }

  Future<List<double>> getWeeklyActivity() async {
    // Get activity data for the last 7 days
    final now = DateTime.now();
    final List<double> activityData = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final activity = await _getActivityForDate(date);
      activityData.add(activity);
    }

    return activityData;
  }

  Future<double> _getActivityForDate(DateTime date) async {
    // Implement this to get actual activity data from your storage
    // Return a value between 0 and 1
    return 0.0; // Placeholder
  }
}
