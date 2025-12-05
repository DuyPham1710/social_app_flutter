import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
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
  );
}

