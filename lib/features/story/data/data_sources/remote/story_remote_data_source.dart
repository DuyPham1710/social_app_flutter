import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/story/data/models/grouped_story_list_model.dart';
import 'package:social_app_fe/features/story/data/models/react_story_model.dart';

part 'story_remote_data_source.g.dart';

@RestApi()
abstract class StoryRemoteDataSource {
  factory StoryRemoteDataSource(Dio dio) = _StoryRemoteDataSource;

  @GET('/story/home')
  Future<GroupedStoryListModel> getHomeStories(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/story/me/archive')
  Future<GroupedStoryListModel> getMyArchivedStories(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/story/me/active')
  Future<GroupedStoryListModel> getMyActiveStories(
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

  /// Xóa story
  @DELETE('/story/{storyId}')
  Future<void> deleteStory(@Path('storyId') String storyId);

  /// Lưu trữ story
  @PATCH('/story/{storyId}/archive')
  Future<void> archiveStory(@Path('storyId') String storyId);

  /// Tạo hoặc cập nhật react cho story (trả về null nếu xóa react)
  @POST('/react-story')
  Future<ReactStoryModel?> createOrUpdateReactStory(
    @Body() Map<String, dynamic> body,
  );

  /// Lấy danh sách react của một story
  @GET('/react-story/{storyId}')
  Future<List<ReactStoryModel>> getStoryReacts(@Path('storyId') String storyId);

  /// Kiểm tra user hiện tại có react story không
  @GET('/react-story/user/current/{storyId}')
  Future<Map<String, dynamic>?> checkUserReactStory(
    @Path('storyId') String storyId,
  );

  /// Cập nhật react của story
  @PATCH('/react-story/{storyId}')
  Future<ReactStoryModel> updateReactStory(
    @Path('storyId') String storyId,
    @Body() Map<String, dynamic> body,
  );

  /// Xóa react của story
  @DELETE('/react-story/{storyId}')
  Future<void> deleteReactStory(@Path('storyId') String storyId);
}
