import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studysquare/features/programs/data/repositories/enrollment_repository.dart';
import 'package:studysquare/features/programs/presentation/provider/enrollment_provider.dart';

void main() {
  group('EnrollmentProvider', () {
    late EnrollmentProvider provider;
    late EnrollmentRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repository = EnrollmentRepository();
      provider = EnrollmentProvider(repository);
    });

    test('initial state is empty', () {
      expect(provider.enrolledProgramIds, isEmpty);
      expect(provider.currentUid, isEmpty);
    });

    test('isEnrolled returns false for non-enrolled program', () {
      expect(provider.isEnrolled('program1'), isFalse);
    });

    test('enroll adds program to enrollments', () async {
      await provider.onAuthChanged('user123');
      await provider.enroll('program1');

      expect(provider.isEnrolled('program1'), isTrue);
      expect(provider.enrolledProgramIds, contains('program1'));
    });

    test('enroll persists to repository', () async {
      await provider.onAuthChanged('user123');
      await provider.enroll('program1');

      final enrollments = await repository.getEnrollments('user123');
      expect(enrollments, contains('program1'));
    });

    test('enroll does not add duplicate programs', () async {
      await provider.onAuthChanged('user123');
      await provider.enroll('program1');
      await provider.enroll('program1');

      expect(provider.enrolledProgramIds.length, equals(1));
    });

    test('unenroll removes program from enrollments', () async {
      await provider.onAuthChanged('user123');
      await provider.enroll('program1');
      await provider.unenroll('program1');

      expect(provider.isEnrolled('program1'), isFalse);
      expect(provider.enrolledProgramIds, isNot(contains('program1')));
    });

    test('unenroll persists to repository', () async {
      await provider.onAuthChanged('user123');
      await provider.enroll('program1');
      await provider.unenroll('program1');

      final enrollments = await repository.getEnrollments('user123');
      expect(enrollments, isNot(contains('program1')));
    });

    test('onAuthChanged loads existing enrollments', () async {
      await repository.saveEnrollments('user123', {'program1', 'program2'});
      await provider.onAuthChanged('user123');

      expect(provider.isEnrolled('program1'), isTrue);
      expect(provider.isEnrolled('program2'), isTrue);
      expect(provider.enrolledProgramIds.length, equals(2));
    });

    test('onAuthChanged clears enrollments for empty uid', () async {
      await provider.onAuthChanged('user123');
      await provider.enroll('program1');
      await provider.onAuthChanged('');

      expect(provider.enrolledProgramIds, isEmpty);
      expect(provider.currentUid, isEmpty);
    });

    test('switching users loads correct enrollments', () async {
      await repository.saveEnrollments('user1', {'program1'});
      await repository.saveEnrollments('user2', {'program2'});

      await provider.onAuthChanged('user1');
      expect(provider.isEnrolled('program1'), isTrue);
      expect(provider.isEnrolled('program2'), isFalse);

      await provider.onAuthChanged('user2');
      expect(provider.isEnrolled('program1'), isFalse);
      expect(provider.isEnrolled('program2'), isTrue);
    });

    test('enroll without user does nothing', () async {
      await provider.enroll('program1');
      expect(provider.enrolledProgramIds, isEmpty);
    });

    test('unenroll without user does nothing', () async {
      await provider.unenroll('program1');
      expect(provider.enrolledProgramIds, isEmpty);
    });
  });
}
