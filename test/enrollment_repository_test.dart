import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studysquare/features/programs/data/repositories/enrollment_repository.dart';

void main() {
  group('EnrollmentRepository', () {
    late EnrollmentRepository repository;

    setUp(() async {
      repository = EnrollmentRepository();
      SharedPreferences.setMockInitialValues({});
    });

    test('getEnrollments returns empty set for new user', () async {
      final enrollments = await repository.getEnrollments('user123');
      expect(enrollments, isEmpty);
    });

    test('saveEnrollments persists enrollments for user', () async {
      final enrollments = {'program1', 'program2', 'program3'};
      await repository.saveEnrollments('user123', enrollments);

      final retrieved = await repository.getEnrollments('user123');
      expect(retrieved, equals(enrollments));
    });

    test('saveEnrollments updates existing enrollments', () async {
      await repository.saveEnrollments('user123', {'program1'});
      await repository.saveEnrollments('user123', {'program1', 'program2'});

      final retrieved = await repository.getEnrollments('user123');
      expect(retrieved, equals({'program1', 'program2'}));
    });

    test('clearEnrollments removes all enrollments for user', () async {
      await repository.saveEnrollments('user123', {'program1', 'program2'});
      await repository.clearEnrollments('user123');

      final retrieved = await repository.getEnrollments('user123');
      expect(retrieved, isEmpty);
    });

    test('enrollments are user-specific', () async {
      await repository.saveEnrollments('user1', {'program1'});
      await repository.saveEnrollments('user2', {'program2'});

      final user1Enrollments = await repository.getEnrollments('user1');
      final user2Enrollments = await repository.getEnrollments('user2');

      expect(user1Enrollments, equals({'program1'}));
      expect(user2Enrollments, equals({'program2'}));
    });

    test('handles empty uid gracefully', () async {
      final enrollments = await repository.getEnrollments('');
      expect(enrollments, isEmpty);

      await repository.saveEnrollments('', {'program1'});
      final enrollments2 = await repository.getEnrollments('');
      expect(enrollments2, isEmpty);
    });
  });
}
