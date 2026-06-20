import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:social_app_fe/features/post/data/models/create_post_response.dart';
import 'package:social_app_fe/features/post/data/models/post_list_model.dart';
import 'package:social_app_fe/features/post/data/models/post_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
import 'package:social_app_fe/features/post/data/models/caption_translation_eligibility_model.dart';
import 'package:social_app_fe/features/post/data/models/post_translation_model.dart';

part 'post_remote_data_source.g.dart';

@RestApi()
abstract class PostRemoteDataSource {
  factory PostRemoteDataSource(Dio dio) = _PostRemoteDataSource;

  @GET('/post/home')
  Future<PostListModel> getHomePosts(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @POST('/react-post')
  Future<ReactPostModel> reactPost(@Body() Map<String, dynamic> body);

  @GET('/post/{postId}')
  Future<PostModel> getPostDetail(@Path('postId') String postId);

  @POST('/post/{postId}/view')
  Future<void> viewPost(@Path('postId') String postId);

  @GET('/post')
  Future<PostListModel> getProfilePosts(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @POST('/post')
  @MultiPart()
  Future<CreatePostResponse> createPost(
    @Part(name: 'caption') String? caption,
    @Part(name: 'layout') String? layout,
    @Part(name: 'privacy_type') String? privacyType,
    @Part(name: 'orders') String? orders,
    @Part(name: 'titles') String? titles,
    @Part(name: 'friends_except') String? friendsExcept,
    @Part(name: 'friends_detail') String? friendsDetail,
    @Part(name: 'taggedUserIds') String? taggedUserIds,
    @Part(name: 'communityId') String? communityId,
    @Part(name: 'location') String? location,
    @Part(name: 'files') List<MultipartFile>? files,
  );

  @GET('/post/user/{userId}')
  Future<PostListModel> getUserPosts(
    @Path('userId') String userId,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/community/{communityId}/posts')
  Future<PostListModel> getCommunityPosts(
    @Path('communityId') String communityId,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/post/community-posts/user')
  Future<PostListModel> getUserCommunityPosts(
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('status') String status,
  );

  @POST('/post/{postId}/report')
  Future<void> reportPost(
    @Path('postId') String postId,
    @Body() Map<String, dynamic> body,
  );

  /// Cập nhật quyền riêng tư của post
  @PATCH('/post/privacy/{postId}')
  Future<void> updatePostPrivacy(
    @Path('postId') String postId,
    @Body() Map<String, dynamic> updatePrivacyDto,
  );

  /// Xóa post
  @DELETE('/post/{postId}')
  Future<void> deletePost(@Path('postId') String postId);

  /// Kiểm tra caption có cần dịch (ngôn ngữ nguồn khác ngôn ngữ máy không)
  @GET('/post/{postId}/caption-translation-eligibility')
  Future<CaptionTranslationEligibilityModel> getCaptionTranslationEligibility(
    @Path('postId') String postId,
    @Query('targetLang') String targetLang,
  );

  /// Dịch caption của post
  @POST('/post/{postId}/translate-caption')
  Future<PostTranslationModel> translateCaption(
    @Path('postId') String postId,
    @Query('targetLang') String targetLang,
  );

  /// Cập nhật trạng thái hiển thị của thẻ trên profile
  @PATCH('/post/{postId}/tag-visibility')
  Future<void> updateTagVisibility(
    @Path('postId') String postId,
    @Body() Map<String, dynamic> body,
  );

  /// Gỡ gắn thẻ
  @DELETE('/post/{postId}/tag')
  Future<void> removeTag(@Path('postId') String postId);

  /// Cập nhật danh sách gắn thẻ của bài viết
  @PATCH('/post')
  Future<void> updatePostTags(@Body() Map<String, dynamic> body);
}
