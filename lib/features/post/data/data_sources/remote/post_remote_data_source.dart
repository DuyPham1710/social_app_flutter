import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:social_app_fe/features/post/data/models/post_list_model.dart';

part 'post_remote_data_source.g.dart';

@RestApi()
abstract class PostRemoteDataSource {
  factory PostRemoteDataSource(Dio dio) = _PostRemoteDataSource;

  @GET('/post/home')
  Future<PostListModel> getHomePosts(
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
