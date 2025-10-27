import '../../data/repositories/progress_repository.dart';

class GetStatsUseCase {
  final ProgressRepository repository;

  GetStatsUseCase(this.repository);

  Future<Map<String, dynamic>> execute() {
    return repository.getStatsData();
  }
}


