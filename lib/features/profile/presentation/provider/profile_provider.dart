// ...existing code...
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studysquare/features/profile/data/models/profile_model.dart';
import 'package:studysquare/features/profile/data/repositories/profile_repository.dart';
import 'package:studysquare/features/programs/data/services/program_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();

  Profile? _profile;
  bool _loading = false;

  Profile? get profile => _profile;
  bool get isLoading => _loading;

  ProfileProvider() {
    loadProfileById(FirebaseAuth.instance.currentUser?.uid ?? '');
  }

  // Future<void> loadProfile() async {
  //   _loading = true;
  //   notifyListeners();
  //   try {
  //     final p = await _repo.loadProfile();
  //     _profile = p;
  //   } catch (_) {
  //     _profile = null;
  //   } finally {
  //     _loading = false;
  //     notifyListeners();
  //   }
  // }

  // NEW: load profile by id (call this after sign-in)
  Future<void> loadProfileById(String id) async {
    _loading = true;
    notifyListeners();
    try {
      final p = await _repo.getProfileById(id);
      _profile = p;
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
    // use saveProfile to replace existing (backwards-compatible)
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

  // NEW: expose onboarding check
  Future<bool> isOnboardingComplete(String id) async {
    return await _repo.isOnboardingComplete(id);
  }

  // NEW: clear in-memory profile (call on sign out)
  void clearLocalProfile() {
    _profile = null;
    notifyListeners();
  }

  // NEW: enroll in a course (adds to profile's enrolled courses)
  Future<void> enrollInCourse(String programId) async {
    if (_profile == null) return;

    final currentCourses = _profile!.enrolledCourses ?? [];
    if (!currentCourses.contains(programId)) {
      _profile!.enrolledCourses = [...currentCourses, programId];
      await saveProfile(_profile!);
    }
  }

  // NEW: unenroll from a course (removes from profile's enrolled courses)
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

  // NEW: check if enrolled in a course via profile
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
// ...existing code...