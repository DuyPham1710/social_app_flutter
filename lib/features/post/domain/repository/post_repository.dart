import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/create_post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/react_post_entity.dart';

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
}
