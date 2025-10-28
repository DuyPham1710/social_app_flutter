import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';

abstract class PostRepository {
  Future<DataState<PostListEntity>> getHomePosts({
    int page = 1,
    int limit = 10,
  });

  Future<DataState<PostListEntity>> getProfilePosts({
    required String ownerId,
    int page = 1,
    int limit = 10,
  });
}
