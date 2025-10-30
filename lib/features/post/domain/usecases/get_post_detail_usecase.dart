import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class GetPostDetailUsecase
    implements UseCase<DataState<PostEntity>, GetPostDetailParams> {
  final PostRepository _repository;

  GetPostDetailUsecase(this._repository);

  @override
  Future<DataState<PostEntity>> call({GetPostDetailParams? params}) {
    final postId = params?.postId;

    return _repository.getPostDetail(postId: postId!);
  }
}

class GetPostDetailParams {
  final String postId;

  const GetPostDetailParams({required this.postId});
}
