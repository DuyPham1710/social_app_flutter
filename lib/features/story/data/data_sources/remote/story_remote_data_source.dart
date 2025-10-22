import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:social_app_fe/features/story/data/models/grouped_story_list_model.dart';

part 'story_remote_data_source.g.dart';

@RestApi()
abstract class StoryRemoteDataSource {
  factory StoryRemoteDataSource(Dio dio) = _StoryRemoteDataSource;

  @GET('/story/home')
  Future<GroupedStoryListModel> getHomeStories(
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
