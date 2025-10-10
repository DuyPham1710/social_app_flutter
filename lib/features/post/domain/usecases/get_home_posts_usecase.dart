import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class GetHomePostsUseCase
    implements UseCase<DataState<PostListEntity>, GetHomePostsParams> {
  final PostRepository _repository;

  GetHomePostsUseCase(this._repository);

  @override
  Future<DataState<PostListEntity>> call({GetHomePostsParams? params}) {
    final page = params?.page ?? 1;
    final limit = params?.limit ?? 10;
    return _repository.getHomePosts(page: page, limit: limit);
  }
}

class GetHomePostsParams {
  final int page;
  final int limit;

  const GetHomePostsParams({this.page = 1, this.limit = 10});
}
