import 'package:flutter/material.dart';
import 'package:studysquare/features/auth/presentation/provider/auth_provider.dart';
import 'package:studysquare/features/profile/data/models/profile_model.dart';
import 'package:studysquare/features/profile/data/repositories/profile_repository.dart';

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
}
