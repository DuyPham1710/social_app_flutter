import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class GetUserPostsParams {
  final String userId;
  final int page;
  final int limit;

  const GetUserPostsParams({
    required this.userId,
    this.page = 1,
    this.limit = 10,
  });
}

class GetUserPostsUseCase
    implements UseCase<DataState<PostListEntity>, GetUserPostsParams> {
  final PostRepository repository;

  GetUserPostsUseCase(this.repository);

  @override
  Future<DataState<PostListEntity>> call({GetUserPostsParams? params}) async {
    if (params == null) {
      throw ArgumentError('GetUserPostsParams cannot be null');
    }

    return await repository.getUserPosts(
      userId: params.userId,
      page: params.page,
      limit: params.limit,
    );
  }
}
