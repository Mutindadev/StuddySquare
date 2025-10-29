import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class BadgesRepository {
  Future<List<dynamic>> fetchBadges() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/progress_data.json');
    final data = jsonDecode(jsonString);
    return data['badges'] ?? [];
  }
}
