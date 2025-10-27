# Enrollment State & Progress Gating Implementation

## Overview
This implementation adds enrollment state management and JSON-driven program content to the StudySquare Flutter app, enabling users to enroll in programs, track their progress, and have their enrollment persist across app sessions.

## Features Implemented

### 1. JSON-Based Program Data
- **File**: `assets/data/programs.json`
- **Content**: 5 comprehensive programs with detailed weekly modules:
  - AI & ML Skill Development (8 weeks)
  - Web Development Bootcamp (8 weeks)
  - Cybersecurity Fundamentals (6 weeks)
  - Mobile App Development (6 weeks)
  - Data Analytics with Python (6 weeks)
- Each program includes:
  - Unique ID for enrollment tracking
  - Title, description, duration, and difficulty level
  - Learning outcomes
  - Weekly modules with tasks (READING/QUIZ/PROJECT)

### 2. State Management with Provider
- **EnrollmentProvider**: ChangeNotifier that manages enrollment state
  - `isEnrolled(programId)`: Check if user is enrolled
  - `enroll(programId)`: Enroll in a program
  - `unenroll(programId)`: Unenroll from a program
  - `onAuthChanged(uid)`: Load enrollments for a user
  
- **EnrollmentRepository**: Handles persistence using SharedPreferences
  - Stores enrollments per user with format: `enrollments_{uid}`
  - JSON serialization for data storage

- **ProgramService**: Loads program data from JSON assets
  - Async loading with error handling
  - Returns empty list on failure

### 3. UI Updates

#### Program Listings Page
- Uses `FutureBuilder` to load programs from JSON
- Shows loading spinner while loading
- Displays "Enrolled" badge for enrolled programs (green chip)
- Changes CTA text:
  - "View Details" for non-enrolled programs
  - "Continue" for enrolled programs
- Uses `Consumer<EnrollmentProvider>` for reactive updates

#### Program Detail Page
- Uses `Consumer<EnrollmentProvider>` for button state
- Button text changes based on enrollment:
  - "Enroll Now" for non-enrolled programs
  - "Continue" for enrolled programs
- Enrollment happens immediately on button tap
- Navigation to EnrolledCoursePage works for both states

### 4. Progress Gating
The existing `EnrolledCoursePage` already implements progress gating:
- Week 1 is always unlocked
- Later weeks require all tasks in previous weeks to be completed
- Locked weeks show a lock icon and snackbar message
- Progress is tracked per program using SharedPreferences

### 5. Persistence
- Enrollments persist using SharedPreferences
- Key format: `enrollments_{uid}` where uid is the user ID
- Data stored as JSON array of program IDs
- Automatically loaded on auth change via `onAuthChanged()`

## File Structure
```
lib/
├── features/
│   └── programs/
│       ├── data/
│       │   ├── repositories/
│       │   │   └── enrollment_repository.dart
│       │   └── services/
│       │       └── program_service.dart
│       ├── providers/
│       │   └── enrollment_provider.dart
│       └── presentation/
│           └── pages/
│               ├── program_listings_page.dart (updated)
│               └── program_detail_page.dart (updated)
├── main.dart (updated with ChangeNotifierProvider)
assets/
└── data/
    └── programs.json
test/
├── enrollment_repository_test.dart
├── enrollment_provider_test.dart
├── program_service_test.dart
└── enrollment_integration_test.dart
```

## Dependencies Added
- `provider: ^6.1.1` - State management
- `shared_preferences: ^2.2.2` - Already present, used for persistence

## Testing

### Unit Tests
1. **enrollment_repository_test.dart**
   - Tests data persistence
   - Tests user-specific storage
   - Tests error handling

2. **enrollment_provider_test.dart**
   - Tests state management
   - Tests user switching
   - Tests enrollment/unenrollment flows

3. **program_service_test.dart**
   - Tests JSON loading
   - Tests error handling

4. **enrollment_integration_test.dart**
   - Tests full enrollment flow
   - Tests UI state changes
   - Tests persistence across provider recreation

### Running Tests
```bash
# Run all tests
fvm flutter test

# Run specific test file
fvm flutter test test/enrollment_provider_test.dart

# Run with coverage
fvm flutter test --coverage
```

## Manual Verification Steps

1. **Initial State**
   - Launch app
   - Navigate to Program Listings
   - Verify 5 programs are displayed
   - Verify no "Enrolled" badges appear

2. **Enrollment Flow**
   - Tap on any program to view details
   - Verify "Enroll Now" button is shown
   - Tap "Enroll Now"
   - Verify navigation to EnrolledCoursePage
   - Go back to Program Listings
   - Verify "Enrolled" badge appears on the enrolled program
   - Verify CTA changed to "Continue"

3. **Persistence**
   - Enroll in 2-3 programs
   - Close the app completely
   - Reopen the app
   - Navigate to Program Listings
   - Verify all enrolled programs still show "Enrolled" badge
   - Verify "Continue" CTA persists

4. **Progress Gating**
   - Open an enrolled course
   - Verify Week 1 is unlocked
   - Verify Week 2+ are locked
   - Complete all tasks in Week 1
   - Verify Week 2 unlocks

5. **UI Layout**
   - Verify status chips (level + enrolled) don't cause title wrapping
   - Verify cards maintain consistent spacing
   - Verify purple theme is consistent

## Design Decisions

### Why Provider?
- Lightweight and Flutter-recommended
- Good integration with existing codebase
- Easy to test and maintain

### Why SharedPreferences?
- No backend API required (per requirements)
- Simple key-value storage
- Built-in JSON serialization support
- Fast local access

### Why Individual Week Modules?
- Matches problem statement requirement for "tasks per week"
- Enables granular progress tracking
- Better UX for learners to see weekly structure
- Clearer gating implementation

### User ID Handling
- Currently uses 'demo_user' as a placeholder
- Ready to integrate with Firebase Auth when available
- Simply call `enrollmentProvider.onAuthChanged(firebaseUser.uid)` on auth state changes

## Future Enhancements
1. Firebase Auth integration - replace 'demo_user' with actual user ID
2. Backend sync for enrollment data
3. Progress analytics and reporting
4. Certificate generation upon completion
5. Social features (share progress, leaderboards)

## Known Limitations
- Single demo user ('demo_user') - will work with multi-user once Firebase Auth is integrated
- No backend sync - enrollments are local only
- No enrollment date tracking - could be added to repository if needed

## Migration Notes
- Existing progress tracking in `EnrolledCoursePage` is preserved
- Old hardcoded programs in `ProgramListingsPage` are replaced with JSON data
- No breaking changes to existing features
- All existing UI styling preserved
