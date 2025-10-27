import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocalJsonService {
  Future<Map<String, dynamic>> loadDashboard() async {
    final jsonString = await rootBundle.loadString('assets/data/dashboard.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  Future<List<dynamic>> loadNotifications() async {
    final jsonString = await rootBundle.loadString('assets/data/notifications.json');
    return json.decode(jsonString) as List<dynamic>;
  }
}
