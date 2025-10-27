import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studysquare/features/programs/data/models/program.dart';
import 'package:studysquare/features/programs/presentation/provider/program_admin_provider.dart';

void main() {
  group('ProgramAdminProvider', () {
    late ProgramAdminProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      provider = ProgramAdminProvider();
    });

    test('initial state is empty', () {
      expect(provider.userPrograms, isEmpty);
      expect(provider.currentUid, isEmpty);
    });

    test('onAuthChanged loads user programs', () async {
      await provider.onAuthChanged('user123');
      expect(provider.currentUid, equals('user123'));
      expect(provider.userPrograms, isEmpty);
    });

    test('onAuthChanged clears programs for empty uid', () async {
      await provider.onAuthChanged('user123');
      
      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );
      
      await provider.addProgram(program);
      expect(provider.userPrograms.length, equals(1));

      await provider.onAuthChanged('');
      expect(provider.currentUid, isEmpty);
      expect(provider.userPrograms, isEmpty);
    });

    test('addProgram adds new program', () async {
      await provider.onAuthChanged('user123');

      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program);
      expect(provider.userPrograms.length, equals(1));
      expect(provider.userPrograms.first.id, equals('test_prog'));
    });

    test('addProgram does not add duplicate programs', () async {
      await provider.onAuthChanged('user123');

      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program);
      await provider.addProgram(program);
      expect(provider.userPrograms.length, equals(1));
    });

    test('addProgram without user does nothing', () async {
      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program);
      expect(provider.userPrograms, isEmpty);
    });

    test('updateProgram updates existing program', () async {
      await provider.onAuthChanged('user123');

      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program);

      final updatedProgram = program.copyWith(title: 'Updated Title');
      await provider.updateProgram(updatedProgram);

      expect(provider.userPrograms.length, equals(1));
      expect(provider.userPrograms.first.title, equals('Updated Title'));
    });

    test('updateProgram without matching program does nothing', () async {
      await provider.onAuthChanged('user123');

      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program);

      final differentProgram = Program(
        id: 'different_prog',
        title: 'Different Program',
        description: 'Different description',
        duration: '2 weeks',
        level: 'Advanced',
        learning: ['Different learning'],
        modules: [],
      );

      await provider.updateProgram(differentProgram);
      expect(provider.userPrograms.length, equals(1));
      expect(provider.userPrograms.first.id, equals('test_prog'));
    });

    test('removeProgram removes program', () async {
      await provider.onAuthChanged('user123');

      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program);
      expect(provider.userPrograms.length, equals(1));

      await provider.removeProgram('test_prog');
      expect(provider.userPrograms, isEmpty);
    });

    test('removeProgram without matching program does nothing', () async {
      await provider.onAuthChanged('user123');

      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program);
      await provider.removeProgram('different_id');
      expect(provider.userPrograms.length, equals(1));
    });

    test('getProgramById returns correct program', () async {
      await provider.onAuthChanged('user123');

      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program);

      final retrieved = provider.getProgramById('test_prog');
      expect(retrieved, isNotNull);
      expect(retrieved?.id, equals('test_prog'));
    });

    test('getProgramById returns null for non-existent program', () async {
      await provider.onAuthChanged('user123');

      final retrieved = provider.getProgramById('non_existent');
      expect(retrieved, isNull);
    });

    test('clearUserPrograms clears all programs', () async {
      await provider.onAuthChanged('user123');

      final program1 = Program(
        id: 'test_prog_1',
        title: 'Test Program 1',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      final program2 = Program(
        id: 'test_prog_2',
        title: 'Test Program 2',
        description: 'Test description',
        duration: '6 weeks',
        level: 'Intermediate',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program1);
      await provider.addProgram(program2);
      expect(provider.userPrograms.length, equals(2));

      await provider.clearUserPrograms();
      expect(provider.userPrograms, isEmpty);
    });

    test('programs persist across provider instances', () async {
      final provider1 = ProgramAdminProvider();
      await provider1.onAuthChanged('user123');

      final program = Program(
        id: 'test_prog',
        title: 'Test Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider1.addProgram(program);

      // Create a new provider instance to simulate app restart
      final provider2 = ProgramAdminProvider();
      await provider2.onAuthChanged('user123');

      expect(provider2.userPrograms.length, equals(1));
      expect(provider2.userPrograms.first.id, equals('test_prog'));
    });

    test('different users have separate programs', () async {
      await provider.onAuthChanged('user1');

      final program1 = Program(
        id: 'user1_prog',
        title: 'User 1 Program',
        description: 'Test description',
        duration: '4 weeks',
        level: 'Beginner',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program1);

      await provider.onAuthChanged('user2');
      expect(provider.userPrograms, isEmpty);

      final program2 = Program(
        id: 'user2_prog',
        title: 'User 2 Program',
        description: 'Test description',
        duration: '6 weeks',
        level: 'Intermediate',
        learning: ['Test learning'],
        modules: [],
      );

      await provider.addProgram(program2);
      expect(provider.userPrograms.length, equals(1));
      expect(provider.userPrograms.first.id, equals('user2_prog'));

      // Switch back to user1
      await provider.onAuthChanged('user1');
      expect(provider.userPrograms.length, equals(1));
      expect(provider.userPrograms.first.id, equals('user1_prog'));
    });
  });
}
