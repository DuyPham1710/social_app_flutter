import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/search/domain/repository/search_repository.dart';

class DeleteSearchHistoryUseCase {
  final SearchRepository repository;

  DeleteSearchHistoryUseCase(this.repository);

  Future<DataState<void>> call({
    required String historyId,
  }) {
    return repository.deleteSearchHistory(historyId: historyId);
  }
}

