import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class RemoveTagUsecase implements UseCase<DataState<void>, String> {
  final PostRepository _repository;

  RemoveTagUsecase(this._repository);

  @override
  Future<DataState<void>> call({String? params}) {
    return _repository.removeTag(postId: params!);
  }
}
