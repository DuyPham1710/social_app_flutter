import '../repository/chat_repository.dart';

class ReactMessageUseCase {
  final ChatRepository _chatRepository;

  ReactMessageUseCase(this._chatRepository);

  void call({
    required String userId,
    required String conversationId,
    required String messageId,
    required String emojiId,
  }) {
    _chatRepository.reactMessage(
      userId: userId,
      conversationId: conversationId,
      messageId: messageId,
      emojiId: emojiId,
    );
  }
}

