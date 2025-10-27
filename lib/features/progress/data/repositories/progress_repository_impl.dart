import '../../domain/repositories/progress_repository.dart';
import '../data_sources/progress_local_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDataSource localDataSource;

  ProgressRepositoryImpl(this.localDataSource);

  @override
  Future<Map<String, dynamic>> getProgressData() async {
    return await localDataSource.fetchProgressData();
  }
}
