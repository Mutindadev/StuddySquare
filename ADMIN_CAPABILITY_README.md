# Admin Capability: User-Created Programs

## Overview
This implementation adds the ability for users to create custom programs at runtime that are persisted per user and merged with the default asset programs.

## Architecture

### ProgramAdminProvider
A `ChangeNotifier` provider that manages user-created programs with the following features:

- **Per-User Persistence**: Programs are stored using SharedPreferences with key pattern `user_programs_<uid>`
- **CRUD Operations**: Complete create, read, update, and delete functionality
- **JSON Serialization**: Programs are serialized/deserialized using the existing `Program` model

### Integration
The implementation integrates seamlessly with existing code:

1. **ProgramService**: Updated `loadPrograms()` to accept optional `userPrograms` parameter
2. **ProgramListingsPage**: Now uses `Consumer<ProgramAdminProvider>` to access user programs
3. **Main.dart**: Uses `MultiProvider` to provide both `EnrollmentProvider` and `ProgramAdminProvider`

## Usage

### Accessing the Provider
```dart
// In any widget that needs access to user programs
final adminProvider = Provider.of<ProgramAdminProvider>(context);
```

### Adding a Program
```dart
final newProgram = Program(
  id: 'custom_prog_${DateTime.now().millisecondsSinceEpoch}',
  title: 'My Custom Program',
  description: 'A user-created program',
  duration: '4 weeks',
  level: 'Beginner',
  learning: ['Learn custom skills'],
  modules: [
    Module(
      week: 'Week 1',
      title: 'Introduction',
      tasks: [
        Task(name: 'First Task', type: TaskType.reading),
      ],
    ),
  ],
);

await adminProvider.addProgram(newProgram);
```

### Updating a Program
```dart
final updatedProgram = existingProgram.copyWith(
  title: 'Updated Title',
  description: 'Updated description',
);

await adminProvider.updateProgram(updatedProgram);
```

### Removing a Program
```dart
await adminProvider.removeProgram('program_id');
```

### Getting a Program
```dart
final program = adminProvider.getProgramById('program_id');
```

### Clearing All User Programs
```dart
await adminProvider.clearUserPrograms();
```

## Data Flow

1. **On App Start**: 
   - `ProgramAdminProvider` is initialized with `onAuthChanged('demo_user')`
   - User programs are loaded from SharedPreferences

2. **Loading Programs**:
   - `ProgramListingsPage` uses `Consumer<ProgramAdminProvider>`
   - `ProgramService.loadPrograms()` receives `adminProvider.userPrograms`
   - Asset programs are loaded and merged with user programs
   - Combined list is displayed in the UI

3. **Adding Programs**:
   - User creates a new program (via future admin UI)
   - `addProgram()` is called on the provider
   - Program is saved to SharedPreferences
   - `notifyListeners()` triggers UI rebuild
   - Program appears in the listings

## Storage Format

Programs are stored in SharedPreferences as JSON:

**Key**: `user_programs_<uid>` (e.g., `user_programs_demo_user`)

**Value**: JSON array of Program objects
```json
[
  {
    "id": "custom_prog_1",
    "title": "Custom Program",
    "description": "User-created program",
    "duration": "4 weeks",
    "level": "Beginner",
    "learning": ["Skill 1", "Skill 2"],
    "modules": [...]
  }
]
```

## Future Enhancements

To add a full admin UI for creating programs:

1. Create `AdminPage` with form fields for program details
2. Add module/task builders for creating course structure
3. Include validation for required fields
4. Add preview functionality before saving
5. Implement import/export features for sharing programs

Example admin page structure:
```dart
class AdminPage extends StatefulWidget {
  // Form fields for:
  // - Program ID (auto-generated)
  // - Title, Description, Duration, Level
  // - Learning outcomes (list)
  // - Modules builder (add/edit/remove)
  // - Tasks per module (add/edit/remove)
  
  void _saveProgram() async {
    final program = _buildProgramFromForm();
    final adminProvider = context.read<ProgramAdminProvider>();
    await adminProvider.addProgram(program);
    // Navigate back or show success message
  }
}
```

## Testing

Comprehensive tests are included in `test/program_admin_provider_test.dart`:

- Initial state verification
- User authentication changes
- CRUD operations
- Persistence across provider instances
- Multi-user data isolation
- Error handling

Run tests with:
```bash
fvm flutter test test/program_admin_provider_test.dart
```

## Notes

- The implementation uses the same persistence pattern as `EnrollmentProvider`
- Programs are isolated per user (by UID)
- User-created programs appear after asset programs in the list
- The provider is fully compatible with the existing `Program` model
- No breaking changes to existing functionality
