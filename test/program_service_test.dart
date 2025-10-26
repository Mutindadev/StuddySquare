import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/data/services/program_service.dart';

void main() {
  group('ProgramService', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('loadPrograms returns list of Program objects from JSON', () async {
      // Mock the asset loading
      const jsonString = '''
      [
        {
          "id": "test_program",
          "title": "Test Program",
          "description": "A test program for testing purposes",
          "duration": "4 weeks",
          "level": "Beginner",
          "learning": [
            "Learn testing fundamentals",
            "Understand program structure"
          ],
          "modules": [
            {
              "week": "Week 1",
              "title": "Introduction to Testing",
              "tasks": [
                {
                  "name": "Reading: Testing Basics",
                  "type": "reading"
                },
                {
                  "name": "Quiz: Fundamentals",
                  "type": "quiz"
                }
              ]
            }
          ]
        },
        {
          "id": "advanced_program",
          "title": "Advanced Development",
          "description": "Advanced programming concepts",
          "duration": "8 weeks",
          "level": "Advanced",
          "learning": [
            "Master advanced patterns",
            "Build scalable applications"
          ],
          "modules": [
            {
              "week": "Week 1",
              "title": "Advanced Concepts",
              "tasks": [
                {
                  "name": "Project: Complex App",
                  "type": "project"
                }
              ]
            },
            {
              "week": "Week 2", 
              "title": "Performance Optimization",
              "tasks": [
                {
                  "name": "Reading: Optimization Techniques",
                  "type": "reading"
                },
                {
                  "name": "Quiz: Performance",
                  "type": "quiz"
                }
              ]
            }
          ]
        }
      ]
      ''';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'assets/data/programs.json') {
              return jsonString;
            }
            return null;
          });

      final programs = await ProgramService.loadPrograms();

      expect(programs, isNotEmpty);
      expect(programs.length, equals(2));

      // Test first program
      final firstProgram = programs.first;
      expect(firstProgram, isA<Program>());
      expect(firstProgram.id, equals('test_program'));
      expect(firstProgram.title, equals('Test Program'));
      expect(
        firstProgram.description,
        equals('A test program for testing purposes'),
      );
      expect(firstProgram.duration, equals('4 weeks'));
      expect(firstProgram.level, equals('Beginner'));
      expect(firstProgram.levelEnum, equals(ProgramLevel.beginner));
      expect(firstProgram.learning.length, equals(2));
      expect(firstProgram.learning.first, equals('Learn testing fundamentals'));
      expect(firstProgram.modules.length, equals(1));
      expect(firstProgram.totalTasks, equals(2));

      // Test module structure
      final firstModule = firstProgram.modules.first;
      expect(firstModule.week, equals('Week 1'));
      expect(firstModule.title, equals('Introduction to Testing'));
      expect(firstModule.tasks.length, equals(2));

      // Test task structure
      final firstTask = firstModule.tasks.first;
      expect(firstTask.name, equals('Reading: Testing Basics'));
      expect(firstTask.type, equals(TaskType.reading));

      final secondTask = firstModule.tasks[1];
      expect(secondTask.name, equals('Quiz: Fundamentals'));
      expect(secondTask.type, equals(TaskType.quiz));

      // Test second program
      final secondProgram = programs[1];
      expect(secondProgram.id, equals('advanced_program'));
      expect(secondProgram.levelEnum, equals(ProgramLevel.advanced));
      expect(secondProgram.totalTasks, equals(3));
    });

    test('loadPrograms returns empty list on error', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            throw PlatformException(
              code: 'asset_not_found',
              message: 'Unable to load asset',
            );
          });

      final programs = await ProgramService.loadPrograms();
      expect(programs, isEmpty);
    });

    test('loadPrograms handles malformed JSON gracefully', () async {
      const malformedJson = '''
      [
        {
          "id": "incomplete_program",
          "title": "Incomplete Program"
          // Missing required fields
        }
      ]
      ''';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'loadString') {
              return malformedJson;
            }
            return null;
          });

      final programs = await ProgramService.loadPrograms();
      expect(programs, isEmpty);
    });

    test('getProgramById returns correct program when found', () async {
      const jsonString = '''
      [
        {
          "id": "program_1",
          "title": "Program One",
          "description": "First program",
          "duration": "3 weeks",
          "level": "Beginner",
          "learning": ["Learn basics"],
          "modules": []
        },
        {
          "id": "program_2", 
          "title": "Program Two",
          "description": "Second program",
          "duration": "5 weeks",
          "level": "Intermediate",
          "learning": ["Learn more"],
          "modules": []
        }
      ]
      ''';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'loadString') {
              return jsonString;
            }
            return null;
          });

      final program = await ProgramService.getProgramById('program_2');

      expect(program, isNotNull);
      expect(program!.id, equals('program_2'));
      expect(program.title, equals('Program Two'));
      expect(program.levelEnum, equals(ProgramLevel.intermediate));
    });

    test('getProgramById returns null when program not found', () async {
      const jsonString = '''
      [
        {
          "id": "existing_program",
          "title": "Existing Program",
          "description": "An existing program",
          "duration": "4 weeks",
          "level": "Beginner",
          "learning": [],
          "modules": []
        }
      ]
      ''';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'loadString') {
              return jsonString;
            }
            return null;
          });

      final program = await ProgramService.getProgramById(
        'non_existent_program',
      );
      expect(program, isNull);
    });

    test('Program model handles all task types correctly', () async {
      const jsonString = '''
      [
        {
          "id": "task_types_program",
          "title": "Task Types Program", 
          "description": "Program with all task types",
          "duration": "2 weeks",
          "level": "Intermediate",
          "learning": ["Learn all task types"],
          "modules": [
            {
              "week": "Week 1",
              "title": "All Task Types",
              "tasks": [
                {
                  "name": "Reading Assignment",
                  "type": "reading"
                },
                {
                  "name": "Knowledge Quiz", 
                  "type": "quiz"
                },
                {
                  "name": "Practical Project",
                  "type": "project"
                },
                {
                  "name": "Unknown Task Type",
                  "type": "unknown"
                }
              ]
            }
          ]
        }
      ]
      ''';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'loadString') {
              return jsonString;
            }
            return null;
          });

      final programs = await ProgramService.loadPrograms();
      final program = programs.first;
      final tasks = program.modules.first.tasks;

      expect(tasks[0].type, equals(TaskType.reading));
      expect(tasks[1].type, equals(TaskType.quiz));
      expect(tasks[2].type, equals(TaskType.project));
      expect(tasks[3].type, equals(TaskType.reading)); // Default fallback
    });

    test('Program copyWith method works correctly', () async {
      const jsonString = '''
      [
        {
          "id": "original_program",
          "title": "Original Title",
          "description": "Original description", 
          "duration": "4 weeks",
          "level": "Beginner",
          "learning": ["Original learning"],
          "modules": []
        }
      ]
      ''';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
            MethodCall methodCall,
          ) async {
            if (methodCall.method == 'loadString') {
              return jsonString;
            }
            return null;
          });

      final programs = await ProgramService.loadPrograms();
      final originalProgram = programs.first;

      final modifiedProgram = originalProgram.copyWith(
        title: 'Modified Title',
        level: 'Advanced',
      );

      expect(modifiedProgram.id, equals(originalProgram.id));
      expect(modifiedProgram.title, equals('Modified Title'));
      expect(modifiedProgram.level, equals('Advanced'));
      expect(modifiedProgram.description, equals(originalProgram.description));
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('flutter/assets'),
            null,
          );
    });
  });
}
