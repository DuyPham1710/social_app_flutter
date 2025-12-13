import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/search/domain/entities/search_result_entity.dart';
import 'package:social_app_fe/features/search/domain/repository/search_repository.dart';

class SearchUsersUseCase {
  final SearchRepository repository;

  SearchUsersUseCase(this.repository);

  Future<DataState<SearchResultEntity>> call({
    required String query,
    int page = 1,
    int limit = 10,
    bool saveToHistory = true,
  }) {
    return repository.searchUsers(
      query: query,
      page: page,
      limit: limit,
      saveToHistory: saveToHistory,
    );
  }
}

