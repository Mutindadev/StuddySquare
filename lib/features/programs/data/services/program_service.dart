import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:studysquare/features/programs/data/models/program.dart';

class ProgramService {
  static Future<List<Program>> loadPrograms() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/programs.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.map((json) => Program.fromJson(json)).toList();
    } catch (e) {
      print('Error loading programs: $e');
      return [];
    }
  }

  static Future<Program?> getProgramById(String id) async {
    final programs = await loadPrograms();
    try {
      return programs.firstWhere((program) => program.id == id);
    } catch (e) {
      return null;
    }
  }
}
