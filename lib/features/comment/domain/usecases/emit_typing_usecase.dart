import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

/// UseCase để emit typing status
class EmitTypingUseCase implements SyncUseCase<void, EmitTypingParams> {
  final CommentRepository _repository;

  EmitTypingUseCase(this._repository);

  @override
  void call({required EmitTypingParams params}) {
    _repository.emitTyping(postId: params.postId, isTyping: params.isTyping);
  }
}

class EmitTypingParams {
  final String postId;
  final bool isTyping;

  EmitTypingParams({required this.postId, required this.isTyping});
}
