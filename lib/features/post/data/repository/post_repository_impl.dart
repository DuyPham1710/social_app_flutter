import 'package:dio/dio.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:social_app_fe/features/post/data/models/post_list_model.dart';
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

      // Map PostListResponse (data layer) sang PostListEntity (domain layer)
      // final postListEntity = PostListEntity(
      //   data: response.data,
      //   page: response.page,
      //   limit: response.limit,
      //   total: response.total,
      //   hasNext: response.hasNext,
      // );

      return DataStateSuccess(response);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  @override
  Future<DataState<PostListModel>> getProfilePosts({
    required String ownerId,
    int page = 1,
    int limit = 10,
  }) {
    // TODO: implement getProfilePosts
    throw UnimplementedError();
  }
}
