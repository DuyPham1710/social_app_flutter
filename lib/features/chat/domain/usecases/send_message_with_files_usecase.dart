import '../repository/chat_repository.dart';

class SendMessageWithFilesUseCase {
  final ChatRepository _chatRepository;

  SendMessageWithFilesUseCase(this._chatRepository);

  Future<List<Map<String, dynamic>>> call({
    required String conversationId,
    String? text,
    List<String>? filePaths,
    String? replyTo,
  }) async {
    return await _chatRepository.sendMessageWithFiles(
      conversationId: conversationId,
      text: text,
      filePaths: filePaths,
      replyTo: replyTo,
    );
  }
}

