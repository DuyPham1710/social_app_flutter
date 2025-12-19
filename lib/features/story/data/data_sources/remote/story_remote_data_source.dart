import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/story/data/models/grouped_story_list_model.dart';
import 'package:retrofit/http.dart';

part 'story_remote_data_source.g.dart';

@RestApi()
abstract class StoryRemoteDataSource {
  factory StoryRemoteDataSource(Dio dio) = _StoryRemoteDataSource;

  @GET('/story/home')
  Future<GroupedStoryListModel> getHomeStories(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// Tạo story: gửi file và metadata (mediaType, music, privacy,...) trong một request
  @POST('/story')
  @MultiPart()
  Future<void> createStory(
    @Part(name: 'title') String? title,
    @Part(name: 'mediaType') String mediaType,
    @Part(name: 'music') String? music,
    @Part(name: 'privacy_type') String privacyType,
    @Part(name: 'friends_except') String? friendsExcept,
    @Part(name: 'friends_detail') String? friendsDetail,
    @Part(name: 'file') List<MultipartFile>? file,
  );

  /// Cập nhật quyền riêng tư của story
  @PATCH('/story/privacy/{storyId}')
  Future<void> updateStoryPrivacy(
    @Path('storyId') String storyId,
    @Body() Map<String, dynamic> updatePrivacyDto,
  );
}
