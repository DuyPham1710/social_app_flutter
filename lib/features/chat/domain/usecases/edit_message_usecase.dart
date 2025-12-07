import '../repository/chat_repository.dart';

class EditMessageUseCase {
  final ChatRepository _chatRepository;

  EditMessageUseCase(this._chatRepository);

  void call({
    required String userId,
    required String messageId,
    required String newText,
  }) {
    _chatRepository.editMessage(
      userId: userId,
      messageId: messageId,
      newText: newText,
    );
  }
}

