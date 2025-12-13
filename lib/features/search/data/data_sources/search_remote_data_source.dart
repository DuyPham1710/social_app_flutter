import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/search/data/models/search_history_model.dart';
import 'package:social_app_fe/features/search/data/models/search_result_model.dart';

part 'search_remote_data_source.g.dart';

@RestApi()
abstract class SearchRemoteDataSource {
  factory SearchRemoteDataSource(Dio dio) = _SearchRemoteDataSource;

  @GET('/user/search')
  Future<SearchResultModel> searchUsers(
    @Query('query') String query,
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('saveToHistory') bool? saveToHistory,
  );

  @GET('/user/search/history/viewed/{viewedUserId}')
  Future<Map<String, dynamic>> saveViewedUser(
    @Path('viewedUserId') String viewedUserId,
  );

  @GET('/user/search/history')
  Future<List<SearchHistoryModel>> getSearchHistory(
    @Query('limit') int limit,
  );

  @DELETE('/user/search/history/{id}')
  Future<Map<String, dynamic>> deleteSearchHistory(
    @Path('id') String id,
  );

  @DELETE('/user/search/history/clear')
  Future<Map<String, dynamic>> clearAllSearchHistory();
}

