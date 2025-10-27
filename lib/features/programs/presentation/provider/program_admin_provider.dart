import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/program.dart';

/// Provider for managing user-created programs.
/// Persists programs per user (uid) using SharedPreferences.
class ProgramAdminProvider extends ChangeNotifier {
  static const String _keyPrefix = 'user_programs_';
  String _currentUid = '';
  List<Program> _userPrograms = [];

  /// Gets the current user ID.
  String get currentUid => _currentUid;

  /// Gets all user-created programs for the current user.
  List<Program> get userPrograms => List.unmodifiable(_userPrograms);

  /// Called when the authenticated user changes.
  /// Loads user-created programs for the new user.
  Future<void> onAuthChanged(String uid) async {
    _currentUid = uid;

    if (uid.isEmpty) {
      _userPrograms = [];
    } else {
      _userPrograms = await _loadUserPrograms(uid);
    }

    notifyListeners();
  }

  /// Adds a new user-created program.
  Future<void> addProgram(Program program) async {
    if (_currentUid.isEmpty) return;

    // Check if program with same ID already exists
    if (_userPrograms.any((p) => p.id == program.id)) {
      return;
    }

    _userPrograms.add(program);
    await _saveUserPrograms(_currentUid, _userPrograms);
    notifyListeners();
  }

  /// Updates an existing user-created program.
  Future<void> updateProgram(Program program) async {
    if (_currentUid.isEmpty) return;

    final index = _userPrograms.indexWhere((p) => p.id == program.id);
    if (index == -1) return;

    _userPrograms[index] = program;
    await _saveUserPrograms(_currentUid, _userPrograms);
    notifyListeners();
  }

  /// Removes a user-created program by ID.
  Future<void> removeProgram(String programId) async {
    if (_currentUid.isEmpty) return;

    final initialLength = _userPrograms.length;
    _userPrograms.removeWhere((p) => p.id == programId);

    if (_userPrograms.length != initialLength) {
      await _saveUserPrograms(_currentUid, _userPrograms);
      notifyListeners();
    }
  }

  /// Gets a user-created program by ID.
  Program? getProgramById(String programId) {
    try {
      return _userPrograms.firstWhere((p) => p.id == programId);
    } catch (e) {
      return null;
    }
  }

  /// Loads user-created programs from SharedPreferences.
  Future<List<Program>> _loadUserPrograms(String uid) async {
    if (uid.isEmpty) return [];

    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$uid';
    final json = prefs.getString(key);

    if (json == null) return [];

    try {
      final List<dynamic> list = jsonDecode(json);
      return list.map((item) => Program.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Saves user-created programs to SharedPreferences.
  Future<void> _saveUserPrograms(String uid, List<Program> programs) async {
    if (uid.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$uid';
    final json = jsonEncode(programs.map((p) => p.toJson()).toList());
    await prefs.setString(key, json);
  }

  /// Clears all user-created programs for the current user.
  Future<void> clearUserPrograms() async {
    if (_currentUid.isEmpty) return;

    _userPrograms = [];
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$_currentUid';
    await prefs.remove(key);
    notifyListeners();
  }
}
