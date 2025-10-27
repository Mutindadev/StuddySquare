import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studysquare/core/theme/app_theme.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/data/repositories/enrollment_repository.dart';
import 'package:studysquare/features/programs/presentation/pages/program_detail_page.dart';
import 'package:studysquare/features/programs/presentation/provider/enrollment_provider.dart';

void main() {
  group('Enrollment Integration Tests', () {
    late EnrollmentProvider enrollmentProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      enrollmentProvider = EnrollmentProvider(EnrollmentRepository());
      await enrollmentProvider.onAuthChanged('test_user');
    });

    testWidgets(
      'Program detail page shows "Enroll Now" for unenrolled program',
      (WidgetTester tester) async {
        final program = Program.fromJson({
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
              'tasks': [
                {'name': 'Reading: Introduction', 'type': 'reading'},
              ],
            },
          ],
        });

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
        expect(find.text('Continue Learning'), findsNothing);
      },
    );

    testWidgets(
      'Program detail page shows "Continue Learning" for enrolled program',
      (WidgetTester tester) async {
        final program = Program.fromJson({
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
              'tasks': [
                {'name': 'Reading: Introduction', 'type': 'reading'},
              ],
            },
          ],
        });

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

        expect(find.text('Continue Learning'), findsOneWidget);
        expect(find.text('Enroll Now'), findsNothing);
      },
    );

    testWidgets('Tapping "Enroll Now" enrolls user in program', (
      WidgetTester tester,
    ) async {
      final program = Program.fromJson({
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
            'tasks': [
              {'name': 'Reading: Introduction', 'type': 'reading'},
            ],
          },
        ],
      });

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

    testWidgets('Enrollment persists across provider recreation', (
      WidgetTester tester,
    ) async {
      // Enroll in a program
      await enrollmentProvider.enroll('test_program');

      // Create a new provider with the same repository
      final newProvider = EnrollmentProvider(EnrollmentRepository());
      await newProvider.onAuthChanged('test_user');

      // Verify enrollment persisted
      expect(newProvider.isEnrolled('test_program'), isTrue);
    });

    testWidgets('Program detail page displays correct program information', (
      WidgetTester tester,
    ) async {
      final program = Program.fromJson({
        'id': 'advanced_program',
        'title': 'Advanced Flutter Development',
        'description': 'Learn advanced Flutter concepts and patterns',
        'duration': '8 weeks',
        'level': 'Advanced',
        'learning': [
          'Master state management',
          'Build scalable applications',
          'Implement clean architecture',
        ],
        'modules': [
          {
            'week': 'Week 1',
            'title': 'State Management',
            'tasks': [
              {'name': 'Reading: Provider vs Bloc', 'type': 'reading'},
              {'name': 'Quiz: State Management', 'type': 'quiz'},
              {'name': 'Project: Todo App', 'type': 'project'},
            ],
          },
          {
            'week': 'Week 2',
            'title': 'Clean Architecture',
            'tasks': [
              {'name': 'Reading: Clean Code Principles', 'type': 'reading'},
              {'name': 'Quiz: Architecture Patterns', 'type': 'quiz'},
            ],
          },
        ],
      });

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

      // Verify program information is displayed
      expect(find.text('Advanced Flutter Development'), findsOneWidget);
      expect(
        find.text('Learn advanced Flutter concepts and patterns'),
        findsOneWidget,
      );
      expect(find.text('8 weeks'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);

      // Verify learning objectives are displayed
      expect(find.text('Master state management'), findsOneWidget);
      expect(find.text('Build scalable applications'), findsOneWidget);

      // Verify module count and task count
      expect(find.text('5'), findsOneWidget); // Total tasks
      expect(find.text('2'), findsOneWidget); // Total modules
    });

    testWidgets('Program with no modules shows appropriate message', (
      WidgetTester tester,
    ) async {
      final program = Program.fromJson({
        'id': 'empty_program',
        'title': 'Coming Soon Program',
        'description': 'This program is coming soon',
        'duration': '6 weeks',
        'level': 'Intermediate',
        'learning': ['Learn new skills'],
        'modules': [], // Empty modules
      });

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

      // Should still show enroll button even with no modules
      expect(find.text('Enroll Now'), findsOneWidget);
      expect(find.text('0'), findsWidgets); // Should show 0 tasks and 0 modules
    });
  });
}
