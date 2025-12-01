import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import '../repository/chat_repository.dart';

/// UseCase để lắng nghe conversation:updated events
class ListenConversationUpdateUseCase
    implements StreamUseCase<ConversationEntity, NoParams> {
  final ChatRepository _repository;

  ListenConversationUpdateUseCase(this._repository);

  @override
  Stream<ConversationEntity> call({required NoParams params}) {
    return _repository.onConversationUpdate;
  }
}