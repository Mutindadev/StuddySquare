import 'package:flutter/foundation.dart';
import 'package:studysquare/features/profile/presentation/provider/profile_provider.dart';

class ProgressRepository {
  // Returns the "stats" section from the JSON file
  // Future<Map<String, dynamic>> getStatsData() async {
  //   try {
  //     final String jsonString =
  //         await rootBundle.loadString('assets/data/progress_data.json');
  //     final Map<String, dynamic> jsonData = json.decode(jsonString);

  //     // ✅ Ensure we actually have "stats" and it's a Map
  //     final stats = jsonData['stats'];
  //     if (stats == null || stats is! Map) {
  //       debugPrint('⚠️ Invalid or missing "stats" key in JSON.');
  //       return {};
  //     }

  //     return Map<String, dynamic>.from(stats);
  //   } catch (e) {
  //     debugPrint('❌ Error loading stats data: $e');
  //     return {};
  //   }
  // }

  Future<Map<String, dynamic>> getStatsData() async {
    try {
      final profileProvider = ProfileProvider();
      final stats = await profileProvider.getOverallStats();

      return {
        'total_xp': stats['total_xp'],
        'day_streak': stats['day_streak'],
        'lessons_done': stats['lessons_done'],
        'hours_learned': stats['hours_learned'],
      };
    } catch (e) {
      debugPrint('❌ Error loading stats data: $e');
      return {};
    }
  }
}
