import 'package:flutter/foundation.dart';

import '../../data/repositories/enrollment_repository.dart';

/// Provider for managing enrollment state.
/// Tracks which programs a user is enrolled in and notifies listeners of changes.
class EnrollmentProvider extends ChangeNotifier {
  final EnrollmentRepository _repository;
  String _currentUid = '';
  Set<String> _enrolledProgramIds = {};

  EnrollmentProvider(this._repository);

  /// Returns true if the program with the given ID is enrolled.
  bool isEnrolled(String programId) {
    return _enrolledProgramIds.contains(programId);
  }

  /// Enrolls in a program with the given ID.
  Future<void> enroll(String programId) async {
    if (programId.isEmpty || _currentUid.isEmpty) return;

    if (!_enrolledProgramIds.contains(programId)) {
      _enrolledProgramIds.add(programId);
      await _repository.saveEnrollments(_currentUid, _enrolledProgramIds);
      notifyListeners();
    }
  }

  /// Unenrolls from a program with the given ID.
  Future<void> unenroll(String programId) async {
    if (programId.isEmpty || _currentUid.isEmpty) return;

    if (_enrolledProgramIds.contains(programId)) {
      _enrolledProgramIds.remove(programId);
      await _repository.saveEnrollments(_currentUid, _enrolledProgramIds);
      notifyListeners();
    }
  }

  /// Called when the authenticated user changes.
  /// Loads enrollment data for the new user.
  Future<void> onAuthChanged(String uid) async {
    _currentUid = uid;

    if (uid.isEmpty) {
      _enrolledProgramIds = {};
    } else {
      _enrolledProgramIds = await _repository.getEnrollments(uid);
    }

    notifyListeners();
  }

  /// Gets the current user ID.
  String get currentUid => _currentUid;

  /// Gets all enrolled program IDs.
  Set<String> get enrolledProgramIds => Set.unmodifiable(_enrolledProgramIds);

  /// Gets the number of enrolled courses.
  int get enrolledCoursesCount => _enrolledProgramIds.length;

  /// Checks if the user has any enrolled courses.
  bool get hasEnrolledCourses => _enrolledProgramIds.isNotEmpty;
}
