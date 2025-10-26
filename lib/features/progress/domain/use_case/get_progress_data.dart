import '../repositories/progress_repository.dart';

class GetProgressData {
  final ProgressRepository repository;

  GetProgressData(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getProgressData();
  }
}
