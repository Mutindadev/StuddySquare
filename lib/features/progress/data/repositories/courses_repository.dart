import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CoursesRepository {
  Future<List<dynamic>> fetchCourses() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/progress_data.json');
    final data = jsonDecode(jsonString);
    return data['courses'] ?? [];
  }
}
