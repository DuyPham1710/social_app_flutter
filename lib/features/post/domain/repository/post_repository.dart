import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<DataState<List<PostEntity>>> getHomePosts({
    int page = 1,
    int limit = 10,
  });
}
