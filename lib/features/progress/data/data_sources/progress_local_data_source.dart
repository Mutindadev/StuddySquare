import 'dart:convert';
import 'package:flutter/services.dart';

class ProgressLocalDataSource {
  Future<Map<String, dynamic>> fetchProgressData() async {
    final jsonString = await rootBundle.loadString('assets/data/progress_data.json');
    return jsonDecode(jsonString);
  }
}
