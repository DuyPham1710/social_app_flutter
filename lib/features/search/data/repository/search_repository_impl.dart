import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:social_app_fe/features/search/domain/entities/search_history_entity.dart';
import 'package:social_app_fe/features/search/domain/entities/search_result_entity.dart';
import 'package:social_app_fe/features/search/domain/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<SearchResultEntity>> searchUsers({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.searchUsers(query, page, limit);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> saveViewedUser({
    required String viewedUserId,
  }) async {
    try {
      await remoteDataSource.saveViewedUser(viewedUserId);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<List<SearchHistoryEntity>>> getSearchHistory({
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getSearchHistory(limit);
      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> deleteSearchHistory({
    required String historyId,
  }) async {
    try {
      await remoteDataSource.deleteSearchHistory(historyId);
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<void>> clearAllSearchHistory() async {
    try {
      await remoteDataSource.clearAllSearchHistory();
      return const DataStateSuccess(null);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}

