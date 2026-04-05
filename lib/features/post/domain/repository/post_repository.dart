import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/create_post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/caption_translation_eligibility_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_translation_entity.dart';

abstract class PostRepository {
  Future<DataState<PostListEntity>> getHomePosts({
    int page = 1,
    int limit = 10,
  });

  Future<DataState<ReactPostEntity>> reactPost({
    required String postId,
    required String emoji,
  });

  Future<DataState<PostEntity>> getPostDetail({required String postId});
  Future<DataState<PostListEntity>> getProfilePosts({
    int page = 1,
    int limit = 10,
  });

  Future<DataState<PostListEntity>> getUserPosts({
    required String userId,
    int page = 1,
    int limit = 10,
  });

  Future<DataState<String>> createPost({required CreatePostEntity post});

  Future<DataState<void>> reportPost({
    required String postId,
    required String reason,
    String? description,
  });

  /// Cập nhật quyền riêng tư của post
  Future<DataState<void>> updatePostPrivacy({
    required String postId,
    required PrivacyType privacyType,
    List<String>? friendsExcept,
    List<String>? friendsDetail,
  });

  /// Xóa post
  Future<DataState<void>> deletePost({
    required String postId,
  });

  /// Kiểm tra có cần dịch caption theo ngôn ngữ đích (thường là ngôn ngữ máy).
  Future<DataState<CaptionTranslationEligibilityEntity>>
      getCaptionTranslationEligibility({
    required String postId,
    String targetLang = 'en',
  });

  /// Dịch caption của post
  Future<DataState<PostTranslationEntity>> translateCaption({
    required String postId,
    String targetLang = 'en',
  });
}
