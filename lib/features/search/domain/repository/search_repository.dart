import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/search/domain/entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<DataState<SearchResultEntity>> searchUsers({
    required String query,
    int page = 1,
    int limit = 10,
  });
}

