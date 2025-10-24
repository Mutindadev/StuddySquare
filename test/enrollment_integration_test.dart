import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studysquare/features/programs/data/repositories/enrollment_repository.dart';
import 'package:studysquare/features/programs/providers/enrollment_provider.dart';
import 'package:studysquare/features/programs/presentation/pages/program_detail_page.dart';
import 'package:studysquare/core/theme/app_theme.dart';

void main() {
  group('Enrollment Integration Tests', () {
    late EnrollmentProvider enrollmentProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      enrollmentProvider = EnrollmentProvider(EnrollmentRepository());
      await enrollmentProvider.onAuthChanged('test_user');
    });

    testWidgets('Program detail page shows "Enroll Now" for unenrolled program',
        (WidgetTester tester) async {
      final program = {
        'id': 'test_program',
        'title': 'Test Program',
        'description': 'A test program',
        'duration': '4 weeks',
        'level': 'Beginner',
        'learning': ['Learn testing'],
        'modules': [
          {
            'week': 'Week 1',
            'title': 'Introduction',
            'tasks': []
          }
        ],
      };

      await tester.pumpWidget(
        ChangeNotifierProvider<EnrollmentProvider>.value(
          value: enrollmentProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ProgramDetailPage(program: program),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Enroll Now'), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
    });

    testWidgets('Program detail page shows "Continue" for enrolled program',
        (WidgetTester tester) async {
      final program = {
        'id': 'test_program',
        'title': 'Test Program',
        'description': 'A test program',
        'duration': '4 weeks',
        'level': 'Beginner',
        'learning': ['Learn testing'],
        'modules': [
          {
            'week': 'Week 1',
            'title': 'Introduction',
            'tasks': []
          }
        ],
      };

      // Enroll in the program first
      await enrollmentProvider.enroll('test_program');

      await tester.pumpWidget(
        ChangeNotifierProvider<EnrollmentProvider>.value(
          value: enrollmentProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ProgramDetailPage(program: program),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Enroll Now'), findsNothing);
    });

    testWidgets('Tapping "Enroll Now" enrolls user in program',
        (WidgetTester tester) async {
      final program = {
        'id': 'test_program',
        'title': 'Test Program',
        'description': 'A test program',
        'duration': '4 weeks',
        'level': 'Beginner',
        'learning': ['Learn testing'],
        'modules': [
          {
            'week': 'Week 1',
            'title': 'Introduction',
            'tasks': []
          }
        ],
      };

      await tester.pumpWidget(
        ChangeNotifierProvider<EnrollmentProvider>.value(
          value: enrollmentProvider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: ProgramDetailPage(program: program),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state
      expect(enrollmentProvider.isEnrolled('test_program'), isFalse);

      // Tap the "Enroll Now" button
      await tester.tap(find.text('Enroll Now'));
      await tester.pumpAndSettle();

      // Verify enrollment occurred
      expect(enrollmentProvider.isEnrolled('test_program'), isTrue);
    });

    testWidgets('Enrollment persists across provider recreation',
        (WidgetTester tester) async {
      // Enroll in a program
      await enrollmentProvider.enroll('test_program');

      // Create a new provider with the same repository
      final newProvider = EnrollmentProvider(EnrollmentRepository());
      await newProvider.onAuthChanged('test_user');

      // Verify enrollment persisted
      expect(newProvider.isEnrolled('test_program'), isTrue);
    });
  });
}
