import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studysquare/features/programs/data/services/program_service.dart';

void main() {
  group('ProgramService', () {
    late ProgramService service;

    setUp(() {
      service = ProgramService();
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('loadPrograms returns list of programs from JSON', () async {
      // Mock the asset loading
      const jsonString = '''
      [
        {
          "id": "test_program",
          "title": "Test Program",
          "description": "A test program",
          "duration": "4 weeks",
          "level": "Beginner",
          "learning": ["Learn testing"],
          "modules": [
            {
              "week": "Week 1",
              "title": "Introduction",
              "tasks": []
            }
          ]
        }
      ]
      ''';

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            return jsonString;
          }
          return null;
        },
      );

      final programs = await service.loadPrograms();

      expect(programs, isNotEmpty);
      expect(programs.first['id'], equals('test_program'));
      expect(programs.first['title'], equals('Test Program'));
    });

    test('loadPrograms returns empty list on error', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          throw PlatformException(code: 'error');
        },
      );

      final programs = await service.loadPrograms();
      expect(programs, isEmpty);
    });
  });
}
