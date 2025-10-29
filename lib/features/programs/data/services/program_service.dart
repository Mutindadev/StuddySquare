import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:studysquare/features/programs/data/models/program.dart';

class ProgramService {
  static Future<List<Program>> loadPrograms({List<Program>? userPrograms}) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/programs.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString);

      final assetPrograms = jsonList.map((json) => Program.fromJson(json)).toList();
      
      // Merge asset programs with user-created programs
      if (userPrograms != null && userPrograms.isNotEmpty) {
        return [...assetPrograms, ...userPrograms];
      }
      
      return assetPrograms;
    } catch (e) {
      print('Error loading programs: $e');
      // Return user programs if available, even if asset loading fails
      return userPrograms ?? [];
    }
  }

  static Future<Program?> getProgramById(String id, {List<Program>? userPrograms}) async {
    final programs = await loadPrograms(userPrograms: userPrograms);
    try {
      return programs.firstWhere((program) => program.id == id);
    } catch (e) {
      return null;
    }
  }
}
