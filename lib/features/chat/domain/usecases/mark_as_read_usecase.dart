import '../repository/chat_repository.dart';

class MarkAsReadUseCase {
  final ChatRepository _chatRepository;

  MarkAsReadUseCase(this._chatRepository);

  void call({
    required String userId,
    required String conversationId,
    String? messageId,
  }) {
    _chatRepository.markAsRead(
      userId: userId,
      conversationId: conversationId,
      messageId: messageId,
    );
  }
}

