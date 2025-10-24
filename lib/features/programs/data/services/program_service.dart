import 'dart:convert';
import 'package:flutter/services.dart';

/// Service for loading program data from JSON assets.
class ProgramService {
  /// Loads all programs from the assets/data/programs.json file.
  Future<List<Map<String, dynamic>>> loadPrograms() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/programs.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      // If loading fails, return empty list
      return [];
    }
  }
}
