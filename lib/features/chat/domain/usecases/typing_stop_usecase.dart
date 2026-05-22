import '../repository/chat_repository.dart';

class TypingStopUseCase {
  final ChatRepository _chatRepository;

  TypingStopUseCase(this._chatRepository);

  void call({required String userId, required String conversationId}) {
    _chatRepository.emitTypingStop(
      userId: userId,
      conversationId: conversationId,
    );
  }
}
