import '../repository/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _chatRepository;

  SendMessageUseCase(this._chatRepository);

  void call({
    required String userId,
    required String conversationId,
    String? text,
    List<Map<String, dynamic>>? attachments,
    String? replyTo,
    Map<String, dynamic>? metadata,
    String? storyId,
    String? postId,
  }) {
    _chatRepository.sendMessage(
      userId: userId,
      conversationId: conversationId,
      text: text,
      attachments: attachments,
      replyTo: replyTo,
      metadata: metadata,
      storyId: storyId,
      postId: postId,
    );
  }
}
