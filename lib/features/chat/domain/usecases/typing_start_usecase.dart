import '../repository/chat_repository.dart';

class TypingStartUseCase {
  final ChatRepository _chatRepository;

  TypingStartUseCase(this._chatRepository);

  void call({required String userId, required String conversationId}) {
    _chatRepository.emitTypingStart(
      userId: userId,
      conversationId: conversationId,
    );
  }
}
