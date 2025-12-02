import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';

class ReportPostUseCase
    implements UseCase<DataState<void>, ReportPostParams> {
  final PostRepository _repository;

  ReportPostUseCase(this._repository);

  @override
  Future<DataState<void>> call({ReportPostParams? params}) {
    return _repository.reportPost(
      postId: params!.postId,
      reason: params.reason,
      description: params.description,
    );
  }
}

class ReportPostParams {
  final String postId;
  final String reason;
  final String? description;

  const ReportPostParams({
    required this.postId,
    required this.reason,
    this.description,
  });
}