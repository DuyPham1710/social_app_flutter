import '../repository/chat_repository.dart';

class DeleteMessageUseCase {
  final ChatRepository _chatRepository;

  DeleteMessageUseCase(this._chatRepository);

  void call({
    required String userId,
    required String messageId,
    required bool deleteForEveryone,
  }) {
    _chatRepository.deleteMessage(
      userId: userId,
      messageId: messageId,
      deleteForEveryone: deleteForEveryone,
    );
  }
}

