import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/comment/domain/entities/typing_entity.dart';
import 'package:social_app_fe/features/comment/domain/repository/comment_repository.dart';

/// UseCase để lắng nghe typing events
class ListenTypingUseCase implements StreamUseCase<TypingEntity, NoParams> {
  final CommentRepository _repository;

  ListenTypingUseCase(this._repository);

  @override
  Stream<TypingEntity> call({required NoParams params}) {
    return _repository.typingStream;
  }
}
