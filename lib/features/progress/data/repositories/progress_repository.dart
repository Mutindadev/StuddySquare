import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class ProgressRepository {
  // Returns the "stats" section from the JSON file
  Future<Map<String, dynamic>> getStatsData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/progress_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // ✅ Ensure we actually have "stats" and it's a Map
      final stats = jsonData['stats'];
      if (stats == null || stats is! Map) {
        debugPrint('⚠️ Invalid or missing "stats" key in JSON.');
        return {};
      }

      return Map<String, dynamic>.from(stats);
    } catch (e) {
      debugPrint('❌ Error loading stats data: $e');
      return {};
    }
  }
}

