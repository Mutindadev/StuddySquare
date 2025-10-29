import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class WeeklyActivityRepository {
  Future<Map<String, dynamic>> fetchWeeklyActivity() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/progress_data.json');
    final data = jsonDecode(jsonString);
    return Map<String, dynamic>.from(data['weekly_activity'] ?? {});
  }
}
