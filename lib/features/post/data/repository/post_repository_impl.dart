import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:social_app_fe/features/post/data/models/post_list_model.dart';
import 'package:social_app_fe/features/post/data/models/post_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<DataState<PostListModel>> getHomePosts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getHomePosts(page, limit);

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<ReactPostModel>> reactPost({
    required String postId,
    required String emoji,
  }) async {
    try {
      final response = await remoteDataSource.reactPost({
        'postId': postId,
        'emojiId': emoji,
      });

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<PostModel>> getPostDetail({required String postId}) async {
    try {
      final response = await remoteDataSource.getPostDetail(postId);

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }
}
