import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
import '../repository/chat_repository.dart';

/// UseCase để lắng nghe message:new events
class ListenNewMessageUseCase
    implements StreamUseCase<MessageEntity, NoParams> {
  final ChatRepository _repository;

  ListenNewMessageUseCase(this._repository);

  @override
  Stream<MessageEntity> call({required NoParams params}) {
    return _repository.onNewMessage;
  }
}
