import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocalJsonService {
  // Generic JSON loader
  Future<Map<String, dynamic>> loadJson(String path) async {
    final raw = await rootBundle.loadString(path);
    return json.decode(raw) as Map<String, dynamic>;
  }

  // Dashboard (new or returning user)
  Future<Map<String, dynamic>> loadDashboardJson({bool returningUser = false}) async {
    final path = returningUser
        ? 'assets/mock/dashboard_returning_user.json'
        : 'assets/mock/dashboard_new_user.json';
    return await loadJson(path);
  }

  // Programs list
  Future<Map<String, dynamic>> loadProgramsJson() async {
    return await loadJson('assets/data/programs.json');
  }

  // Program details (with lessons, instructors, etc.)
  Future<Map<String, dynamic>> loadProgramDetailsJson() async {
    return await loadJson('assets/data/programDetails.json');
  }

  // User progress data
  Future<Map<String, dynamic>> loadProgressJson() async {
  final raw = await rootBundle.loadString('assets/data/progress.json');
  return json.decode(raw) as Map<String, dynamic>;
  }

  // Profile data
  Future<Map<String, dynamic>> loadProfileJson() async {
    return await loadJson('assets/mock/profile.json');
  }
}
