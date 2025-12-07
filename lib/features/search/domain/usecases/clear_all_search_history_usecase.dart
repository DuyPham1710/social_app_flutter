import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/search/domain/repository/search_repository.dart';

class ClearAllSearchHistoryUseCase {
  final SearchRepository repository;

  ClearAllSearchHistoryUseCase(this.repository);

  Future<DataState<void>> call() {
    return repository.clearAllSearchHistory();
  }
}

