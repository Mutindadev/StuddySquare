// ...existing code...
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import '../models/profile_model.dart';

class ProfileRepository {
  static const _profileKey =
      'profile_data'; // kept for compatibility if you still use prefs
  static const _fileName = 'profiles.json';

  Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  // NEW: expose local file path for debugging / inspection
  Future<String> getLocalFilePath() async {
    final f = await _localFile();
    return f.path;
  }

  // Ensure file exists. Try to seed from assets if available, otherwise create empty list.
  Future<void> _ensureFileExists() async {
    final file = await _localFile();
    if (!await file.exists()) {
      // Try asset paths (support common and the one in your workspace)
      const assetCandidates = [
        'assets/data/profile.json', // common
        'assets/data./profile.json', // your current file name (contains dot)
        'assets/profile.json',
      ];

      String? seed;
      for (final asset in assetCandidates) {
        try {
          seed = await rootBundle.loadString(asset);
          if (seed.trim().isNotEmpty) {
            if (kDebugMode)
              debugPrint(
                'Seeding profiles file from asset "$asset" to ${file.path}',
              );
            break;
          }
        } catch (_) {
          // ignore missing asset
        }
      }

      if (seed != null && seed.trim().isNotEmpty) {
        await file.writeAsString(seed);
      } else {
        if (kDebugMode)
          debugPrint('Creating empty profiles file at ${file.path}');
        await file.writeAsString(jsonEncode([]));
      }
    }
  }

  Future<List<Profile>> loadAllProfiles() async {
    await _ensureFileExists();
    final file = await _localFile();
    try {
      final content = await file.readAsString();
      final data = jsonDecode(content);

      // data expected to be a List
      if (data is List) {
        return data.map((e) {
          if (e is Map<String, dynamic>) {
            return Profile.fromJson(e);
          }
          return Profile.fromJson(Map<String, dynamic>.from(e));
        }).toList();
      }

      // If saved as single object, wrap it
      if (data is Map) {
        return [Profile.fromJson(Map<String, dynamic>.from(data))];
      }

      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading profiles: $e');
      // on error return empty list
      return [];
    }
  }

  Future<void> _saveAllProfiles(List<Profile> profiles) async {
    final file = await _localFile();
    final encoded = jsonEncode(profiles.map((p) => p.toJson()).toList());
    if (kDebugMode) {
      debugPrint('Saving ${profiles.length} profiles to ${file.path}');
      debugPrint('Payload: $encoded');
    }
    await file.writeAsString(encoded);
  }

  // ...rest of your CRUD methods unchanged...
  // Create: add a profile (email used as unique key)
  Future<Profile> createProfile(Profile profile) async {
    final list = await loadAllProfiles();
    final exists = list.any((p) => p.email == profile.email);
    if (exists) {
      throw Exception('Profile with email ${profile.email} already exists');
    }

    final newList = [...list, profile];
    await _saveAllProfiles(newList);
    return profile;
  }

    // NEW: Read: get profile by id (returns null if not found)
  Future<Profile?> getProfileById(String id) async {
    final list = await loadAllProfiles();
    for (final p in list) {
      if (p.id == id) return p;
    }
    return null;
  }

  // NEW: convenience: check whether onboarding (profile) exists for given id
  Future<bool> isOnboardingComplete(String id) async {
    final p = await getProfileById(id);
    return p != null;
  }

  Future<Profile?> getProfileByEmail(String email) async {
    final list = await loadAllProfiles();
    for (final p in list) {
      if (p.email == email) return p;
    }
    return null;
  }

  Future<void> updateProfileByEmail(Profile profile) async {
    final list = await loadAllProfiles();
    final idx = list.indexWhere((p) => p.email == profile.email);
    if (idx == -1) {
      throw Exception('Profile with email ${profile.email} not found');
    }
    list[idx] = profile;
    await _saveAllProfiles(list);
  }

  Future<void> deleteProfileByEmail(String email) async {
    final list = await loadAllProfiles();
    final newList = list.where((p) => p.email != email).toList();
    await _saveAllProfiles(newList);
  }

  Future<Profile> loadProfile() async {
    final all = await loadAllProfiles();
    if (all.isNotEmpty) return all.first;

    final defaultProfile = Profile(
      // id: FirebaseAuth.instance.currentUser?.uid ?? '',
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'User 1',
      email: 'user1@gmail.com',
      membershipDate: 'October 2025',
      plan: 'Free',
      courses: 3,
      streak: 0,
      totalXP: 0,
      notifications: true,
      dailyGoal: '60 minutes',
      reminderTime: '09:00 AM',
    );
    await _saveAllProfiles([defaultProfile]);
    return defaultProfile;
  }

  Future<void> saveProfile(Profile profile) async {
    final list = await loadAllProfiles();
    final idx = list.indexWhere((p) => p.email == profile.email);
    if (idx >= 0) {
      list[idx] = profile;
    } else {
      list.add(profile);
    }
    await _saveAllProfiles(list);
  }
}
// ...existing code...