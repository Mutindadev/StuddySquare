import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CurrentGoalsRepository {
  Future<Map<String, dynamic>> fetchCurrentGoals() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/progress_data.json');
    final data = jsonDecode(jsonString);
    return Map<String, dynamic>.from(data['current_goals'] ?? {});
  }
}
