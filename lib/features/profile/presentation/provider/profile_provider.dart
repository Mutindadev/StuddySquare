// ...existing code...
import 'package:flutter/material.dart';
import 'package:studysquare/features/profile/data/models/profile_model.dart';
import 'package:studysquare/features/profile/data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repo = ProfileRepository();

  Profile? _profile;
  bool _loading = false;

  Profile? get profile => _profile;
  bool get isLoading => _loading;

  ProfileProvider() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    _loading = true;
    notifyListeners();
    try {
      final p = await _repo.loadProfile();
      _profile = p;
    } catch (_) {
      _profile = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

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
}
// ...existing code...