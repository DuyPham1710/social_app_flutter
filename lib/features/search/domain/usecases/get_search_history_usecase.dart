import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/search/domain/entities/search_history_entity.dart';
import 'package:social_app_fe/features/search/domain/repository/search_repository.dart';

class GetSearchHistoryUseCase {
  final SearchRepository repository;

  GetSearchHistoryUseCase(this.repository);

  Future<DataState<List<SearchHistoryEntity>>> call({int limit = 10}) {
    return repository.getSearchHistory(limit: limit);
  }
}
